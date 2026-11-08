'use strict';
const assert=require('node:assert/strict'),E=require('../dist/center/engine.js');
const s=E.createState();E.validate(s);
assert.equal(E.locationRows(s,{floor:2}).length,30);assert.equal(E.locationRows(s,{floor:3}).length,30);
assert.equal(E.locationRows(s,{zone:'FROZEN'}).length,18);assert.equal(E.locationRows(s,{zone:'CHILLED'}).length,12);
assert.equal(E.locationRows(s,{floor:2}).reduce((n,l)=>n+l.qty,0),840);
assert.equal(E.locationRows(s,{floor:3}).reduce((n,l)=>n+l.qty,0),230);
assert.equal(E.locationRows(s,{search:'우유'}).every(l=>l.sku==='VC-211'),true);
assert.equal(E.locationRows(s,{search:'2F-FZ-A01-B01-L01'}).length,1);
assert.ok(E.locationRows(s,{status:'empty'}).length>0);
for(const o of s.orders)for(const line of o.lines.filter(l=>l.floor!==4&&l.reserved))assert.equal(line.allocations.reduce((n,a)=>n+a.qty,0),line.qty);
// Force a larger-than-one-location line to confirm split allocation and location conservation.
const split=E.createState();split.orders=[];split.jobs=[];for(const x of Object.values(split.stock))x.reserved=0;for(const l of split.locations)l.reserved=0;
const order={id:'SPLIT',created:split.time,route:1,state:'WAIT_STOCK',lines:[{id:'SPLIT-0',sku:'VC-301',floor:3,zone:'BULKY',qty:20,state:'WAIT',reserved:false}],until:null,truck:null,shippedAt:null};split.orders.push(order);E.advance(split,1);assert.ok(order.lines[0].allocations.length>1);E.validate(split);E.advance(split,200);E.validate(split);assert.equal(split.stock['VC-301'].picked,20);
// Every completed receipt changes only its planned location; stock arrives after putaway.
const receiptState=E.createState();receiptState.orders=[];receiptState.jobs=[];for(const x of Object.values(receiptState.stock))x.reserved=0;for(const l of receiptState.locations)l.reserved=0;
const snapshot=new Map(receiptState.locations.map(l=>[l.id,l.qty]));E.advance(receiptState,30);assert.deepEqual(receiptState.locations.map(l=>l.qty),[...snapshot.values()]);E.advance(receiptState,150);E.validate(receiptState);
for(const l of receiptState.locations){const arrived=receiptState.receipts.filter(r=>r.state==='DONE').flatMap(r=>r.items).filter(i=>i.locationId===l.id).reduce((n,i)=>n+i.qty,0);assert.equal(l.qty,snapshot.get(l.id)+arrived)}
// Migrate actual v1 data with in-flight picking, received stock and shipped orders.
const fs=require('node:fs'),path=require('node:path'),vm=require('node:vm');const original=fs.readFileSync(path.join(__dirname,'fixtures','engine-v1.js'),'utf8'),context={module:{exports:{}}};vm.runInNewContext(original,context);const oldE=context.module.exports;
for(const seconds of [0,10,90,500]){const old=JSON.parse(JSON.stringify(oldE.createState()));oldE.advance(old,seconds);const before=JSON.stringify(old.stock),orderStates=JSON.stringify(old.orders.map(o=>o.state));E.migrateState(old);assert.equal(JSON.stringify(old.stock),before);assert.equal(JSON.stringify(old.orders.map(o=>o.state)),orderStates);E.validate(old);E.advance(old,200);E.validate(old)}
E.addOrders(s,220);for(let i=0;i<1800;i++){if(i%150===0)E.addReceipt(s);E.advance(s,1);E.validate(s)}
const corrupted=JSON.parse(JSON.stringify(s));corrupted.locations[0].qty++;assert.throws(()=>E.validate(corrupted));
console.log('PASS: 60 locations, zones, exact initial stock, filters, split picking, putaway destinations, v1 migration, prolonged stock conservation, corruption detection');
