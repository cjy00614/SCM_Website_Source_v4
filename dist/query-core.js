(function(root,factory){const api=factory();if(typeof module==='object')module.exports=api;else root.QueryCore=api})(typeof globalThis!=='undefined'?globalThis:this,function(){
'use strict';
const q=x=>'"'+String(x).replace(/"/g,'""')+'"';
const roles={date:['snapshot_date','기준일자','started_at'],category:['category','물류운영카테고리대분류','SSG대분류','기간계 대분류명'],md:['md_name','대표MD명','오프라인담당명'],supplier:['supplier_name','협력업체명','협력업체','연동공급업체명'],name:['product_name','상품명','물류상품명','오프라인상품명'],id:['offline_product_id','오프라인상품번호','오프라인상품ID','물류상품ID'],stockout:['stockout_hours','품절시간수'],operating:['operating_hours','운영시간수']};
const presets=[
{id:'integrated',label:'01 · 상품별 통합 이력',sql:'SELECT * FROM v_sku_day',description:'날짜와 상품으로 6종 데이터를 연결한 기본 조회입니다.'},
{id:'latest',label:'02 · 최신일 재고 전체',sql:'SELECT * FROM v_latest_inventory',description:'DB의 가장 최근 기준일에 관측된 상품만 조회합니다.'},
{id:'stockout',label:'03 · 최신일 품절 상품',sql:'SELECT * FROM v_latest_inventory WHERE stockout_hours > 0',description:'최신일에 품절시간이 기록된 상품과 동시 관측 신호입니다.'},
{id:'pending',label:'04 · 입하대기 + 품절',sql:'SELECT * FROM v_latest_inventory WHERE pending_quantity > 0 AND stockout_hours > 0',description:'가용화 상태를 확인할 대상이며 원인 확정은 아닙니다.'},
{id:'actions',label:'05 · 조치 우선 검토',sql:'SELECT * FROM v_action_candidates',description:'품절·비가용·판매상태·임박·목표 초과 신호를 확인합니다.'},
{id:'overorder',label:'06 · 50일 이상 재고 추가 발주',sql:'SELECT * FROM v_latest_inventory WHERE coverage_days_14d >= 50 AND order_quantity > 0',description:'재고일 50일 이상인데 추가 발주한 상품입니다. 결과 0도 정상입니다.'},
{id:'stopped',label:'07 · 비판매 상태의 재고',sql:"SELECT * FROM v_latest_inventory WHERE mall_status <> '판매중' AND total_quantity > 0",description:'몰판매상태와 물류 가용 여부를 함께 점검합니다.'},
{id:'daily',label:'08 · 일별 품절·재고 KPI',sql:'SELECT * FROM v_daily_kpi',description:'일별 집계 결과입니다. 날짜별 재고액을 더해 보유재고로 해석하지 마세요.'},
{id:'supplier',label:'09 · 공급업체 납품 성과',sql:'SELECT * FROM v_supplier_receipt_kpi',description:'일별 공급업체 수량 충족률과 부족/지연 전표입니다. 비율 단순 평균에 주의하세요.'},
{id:'locations',label:'10 · 위치재고와 임박 수량',sql:'SELECT * FROM v_location_day',description:'위치재고를 상품별로 합산한 결과입니다.'},
{id:'receipts',label:'11 · 상품별 납품·매입 수량',sql:'SELECT * FROM v_receipt_day',description:'매입수량이 비어 있으면 0으로 바꾸지 않고 NULL을 유지합니다.'},
{id:'quality',label:'12 · DB 데이터 품질 검사',sql:'SELECT * FROM v_data_quality',description:'연결·재고 균형·중복·숫자 변환 이상 건수를 확인합니다.'},
{id:'dictionary',label:'13 · 원본 칼럼 사전',sql:'SELECT * FROM column_dictionary',description:'249개 원본 칼럼과 DB 이름·자료형을 확인합니다.'},
{id:'runs',label:'14 · DB 적재 실행 기록',sql:'SELECT * FROM ingestion_runs',description:'성공/실패와 추가·건너뜀 파일 수를 확인합니다.'}
];
function findRole(columns,role){return (roles[role]||[]).find(x=>columns.some(c=>c.name===x))||null}
function parseValue(v,col){if(/INT|REAL|NUM|DEC|FLOAT|DOUBLE/i.test(col.type||'')){if(String(v).trim()===''||!Number.isFinite(Number(String(v).replace(/,/g,''))))throw Error(col.name+'에 숫자를 입력하세요.');return Number(String(v).replace(/,/g,''))}return String(v)}
function compile(config,columns,options={}){
 const names=new Set(columns.map(c=>c.name)),byName=new Map(columns.map(c=>[c.name,c]));
 const checked=name=>{if(!names.has(name))throw Error('현재 SQL에 없는 칼럼: '+name);return q(name)};
 const conditions=[],params=[];const quick=config.quick||{};
 for(const role of ['category','md','supplier']){const field=findRole(columns,role);if(field&&quick[role]&&options.excludeRole!==role){conditions.push(checked(field)+' = ?');params.push(quick[role])}}
 const date=findRole(columns,'date');if(date){if(quick.from){conditions.push('substr('+checked(date)+',1,10) >= ?');params.push(quick.from)}if(quick.to){conditions.push('substr('+checked(date)+',1,10) <= ?');params.push(quick.to)}}
 if(quick.search){const fields=[findRole(columns,'name'),findRole(columns,'id')].filter(Boolean);if(fields.length){conditions.push('('+fields.map(f=>'CAST('+checked(f)+' AS TEXT) LIKE ? ESCAPE \'\\\'').join(' OR ')+')');const value='%'+String(quick.search).replace(/[\\%_]/g,'\\$&')+'%';fields.forEach(()=>params.push(value))}}
 const advanced=[];
 for(const f of options.skipAdvanced?[]:config.filters||[]){if(!f.column)continue;const col=byName.get(f.column);checked(f.column);const ref=checked(f.column),op=f.operator;if(op==='null'){advanced.push(ref+' IS NULL');continue}if(op==='notnull'){advanced.push(ref+' IS NOT NULL');continue}if(f.value===undefined||String(f.value).trim()==='')continue;
  if(['eq','ne','gt','gte','lt','lte'].includes(op)){advanced.push(ref+' '+({eq:'=',ne:'<>',gt:'>',gte:'>=',lt:'<',lte:'<='}[op])+' ?');params.push(parseValue(f.value,col))}
  else if(op==='contains'||op==='starts'){advanced.push('CAST('+ref+' AS TEXT) LIKE ? ESCAPE \'\\\'');const s=String(f.value).replace(/[\\%_]/g,'\\$&');params.push((op==='contains'?'%':'')+s+'%')}
  else if(op==='in'||op==='notin'){const values=String(f.value).split(',').map(v=>v.trim()).filter(Boolean);if(!values.length)continue;advanced.push(ref+(op==='in'?' IN (':' NOT IN (')+values.map(()=>'?').join(', ')+')');values.forEach(v=>params.push(parseValue(v,col)))}
  else if(op==='between'){if(f.value2===undefined||String(f.value2).trim()==='')throw Error('범위의 끝값을 입력하세요.');advanced.push(ref+' BETWEEN ? AND ?');params.push(parseValue(f.value,col),parseValue(f.value2,col))}
  else throw Error('지원하지 않는 비교 방식입니다.');
 }
 if(advanced.length)conditions.push('('+advanced.join(config.logic==='OR'?' OR ':' AND ')+')');
 const base='FROM (\n'+config.baseSQL+'\n) AS source';const where=conditions.length?'\nWHERE '+conditions.join('\n  AND '):'';
 const groups=(config.groups||[]).filter(Boolean);if(groups.length>3)throw Error('집계 기준은 최대 3개입니다.');groups.forEach(checked);
 let fields,output;
 if(groups.length){let expr;const metric=config.metric||{};if(metric.operation==='count')expr='COUNT(*)';else if(metric.operation==='distinct')expr='COUNT(DISTINCT '+checked(metric.column)+')';else if(metric.operation==='weighted'){const h=findRole(columns,'stockout'),o=findRole(columns,'operating');if(!h||!o)throw Error('품절시간과 운영시간 칼럼이 필요합니다.');expr='100.0 * SUM(CASE WHEN '+checked(o)+' > 0 AND '+checked(h)+' IS NOT NULL THEN '+checked(h)+' END) / NULLIF(SUM(CASE WHEN '+checked(o)+' > 0 AND '+checked(h)+' IS NOT NULL THEN '+checked(o)+' END), 0)'}else{const fn={sum:'SUM',avg:'AVG',min:'MIN',max:'MAX'}[metric.operation];if(!fn)throw Error('집계 방식을 선택하세요.');if(!/INT|REAL|NUM|DEC|FLOAT|DOUBLE/i.test(byName.get(metric.column)?.type||''))throw Error('숫자형 집계 칼럼을 선택하세요.');expr=fn+'('+checked(metric.column)+')'}fields=groups.map(checked).join(', ')+', '+expr+' AS "metric_value"';output=[...groups,'metric_value']}
 else{output=(config.selected||[]).filter(Boolean);if(!output.length)throw Error('표시할 칼럼을 하나 이상 선택하세요.');fields=output.map(checked).join(', ')}
 let sql='SELECT '+fields+'\n'+base+where;if(groups.length)sql+='\nGROUP BY '+groups.map(checked).join(', ');
 if(config.sort&&output.includes(config.sort))sql+='\nORDER BY '+q(config.sort)+(config.direction==='ASC'?' ASC':' DESC');
 return {sql,params,output,whereSQL:base+where,groups};
}
function literal(v){return v===null?'NULL':typeof v==='number'?String(v):"'"+String(v).replace(/'/g,"''")+"'"}
function interpolated(sql,params){let i=0;return sql.replace(/\?/g,()=>literal(params[i++]))}
return {quote:q,presets,findRole,compile,interpolated};
});
