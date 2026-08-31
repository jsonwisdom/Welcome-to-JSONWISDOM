(() => {
  const $ = s => document.querySelector(s);
  const state = {data:null, leaves:[], i:0};

  function norm(v){
    if(v === undefined || v === null || v === "") return null;
    if(typeof v === "boolean") return v ? "TRUE" : "FALSE";
    return String(v);
  }

  function compare(a,b){
    const A=norm(a), B=norm(b);
    if(A===null || B===null) return "HOLD";
    return A===B ? "PASS" : "DIFF";
  }

  function buildLeaves(){
    const [a,b]=state.data.sources;
    state.leaves=state.data.comparison.fields.map(field => ({
      field, a:a.state[field], b:b.state[field],
      result:compare(a.state[field],b.state[field])
    }));
  }

  function renderStats(){
    const counts={PASS:0,DIFF:0,HOLD:0};
    state.leaves.forEach(x => counts[x.result]++);
    document.querySelector("#atomicLeafCount").textContent=state.leaves.length;
    document.querySelector("#atomicPass").textContent=counts.PASS;
    document.querySelector("#atomicDiff").textContent=counts.DIFF;
    document.querySelector("#atomicHold").textContent=counts.HOLD;
  }

  function renderLeaf(){
    if(!state.leaves.length) return;
    const x=state.leaves[state.i % state.leaves.length];
    const [a,b]=state.data.sources;
    document.querySelector("#atomicLeafName").textContent=x.field.toUpperCase();
    document.querySelector("#atomicAName").textContent=a.label;
    document.querySelector("#atomicBName").textContent=b.label;
    document.querySelector("#atomicAValue").textContent=norm(x.a) ?? "NOT PRESENT";
    document.querySelector("#atomicBValue").textContent=norm(x.b) ?? "NOT PRESENT";
    const r=document.querySelector("#atomicResult");
    r.textContent=x.result;
    r.className="atomicResult "+x.result;
    document.querySelector("#atomicMeaning").textContent=
      x.result==="PASS" ? "Both source leaves agree after normalization." :
      x.result==="DIFF" ? "The source leaves differ. Difference is surfaced, not judged." :
      "One path lacks a comparable value; meaning remains HOLD.";
    state.i++;
  }

  async function load(){
    try{
      const res=await fetch("atomic-replay.json?ts="+Date.now(),{cache:"no-store"});
      if(!res.ok) throw new Error("HTTP "+res.status);
      state.data=await res.json();
      buildLeaves();
      renderStats();
      renderLeaf();
      document.querySelector("#atomicStatus").textContent="LIVE SOURCE SNAPSHOT · 5s ROTATION";
      document.querySelector("#atomicSourceA").href=state.data.sources[0].source_url;
      document.querySelector("#atomicSourceB").href=state.data.sources[1].source_url;
    }catch(e){
      document.querySelector("#atomicStatus").textContent="HOLD · "+e.message;
    }
  }

  load();
  setInterval(() => {
    if(state.data) renderLeaf();
    load();
  }, 5000);
})();
