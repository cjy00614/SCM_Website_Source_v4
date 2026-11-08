'use strict';
const assert=require('node:assert/strict');
const E=require('../dist/center/engine.js');
const s=E.createState();
assert.equal(s.docks.inbound.length,3);assert.equal(s.docks.outbound.length,40);
const blocked=s.docks.outbound.find(d=>!d.truck);
assert.ok(E.setBlocked(s,'outbound',blocked.id,true));
const blockedTruck=E.dispatch(s,1,blocked.id);assert.equal(blockedTruck.dock,null);
for(let i=0;i<6;i++)E.addReceipt(s);
assert.equal(E.metrics(s).inOccupied,3);assert.ok(E.metrics(s).inQueue>0);
const before=E.metrics(s).stockQty;E.advance(s,1);E.validate(s);
assert.equal(E.metrics(s).stockQty,before); // Receipt cannot become available before putaway.
E.addOrders(s,200);
let loadingGuardChecked=false;
for(let i=0;i<2200;i++){
 E.advance(s,.5);E.validate(s);
 const t=s.trucks.find(t=>t.loading);
 if(t){assert.equal(E.depart(s,t.id),false);loadingGuardChecked=true;}
}
assert.ok(loadingGuardChecked);assert.ok(E.metrics(s).shipped>0);
const restored=JSON.parse(JSON.stringify(s));assert.ok(E.validate(restored));E.advance(restored,1);E.validate(restored);
// Force a consistent all-stock-zero scenario: reservations must fail atomically.
const empty=E.createState();empty.orders=[];empty.jobs=[];
for(const stock of Object.values(empty.stock))Object.assign(stock,{qty:0,initial:0,received:0,picked:0,reserved:0});
for(const l of empty.locations)Object.assign(l,{qty:0,initial:0,received:0,picked:0,reserved:0});
E.addOrders(empty,10);assert.ok(empty.orders.every(o=>o.state==='WAIT_STOCK'));
assert.equal(E.metrics(empty).reserved,0);E.advance(empty,250);E.validate(empty);
assert.ok(E.metrics(empty).stockQty>0);assert.ok(empty.orders.some(o=>o.state!=='WAIT_STOCK'));
console.log('PASS: 43 docks, maintenance, inbound queue, stock conservation, shortage reservations, loading guard, order shipping, JSON restore');
