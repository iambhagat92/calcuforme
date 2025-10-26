// Simple approximate DLS resource model (for auto-suggestion)
// NOTE: This is an approximation, not the official ICC table.
// Resource percent R ≈ scaled_exponential(oversRemaining) * wicket_factor(wicketsLost)
(function(global){
  function clamp(v, min, max){ return Math.max(min, Math.min(max, v)); }
  function baseCurve(oversRemaining, Omax){
    // normalize exponential so that baseCurve(Omax)=1 and baseCurve(0)=0
    var k = (Omax <= 20) ? 0.12 : 0.055; // steeper for T20
    var num = 1 - Math.exp(-k * oversRemaining);
    var den = 1 - Math.exp(-k * Omax);
    return den > 0 ? (num / den) : 0;
  }
  function wicketFactor(w){
    // Progressive penalty with wickets lost (0..10)
    // f(0)=1, f(5)~0.62, f(10)=0.30
    var x = clamp(w, 0, 10) / 10;
    return clamp(1 - 0.55*x - 0.15*x*x, 0.25, 1);
  }
  function resource(matchType, oversRemaining, wicketsLost){
    var Omax = (matchType === 't20') ? 20 : 50;
    var o = clamp(oversRemaining, 0, Omax);
    var w = clamp(wicketsLost, 0, 10);
    var r = baseCurve(o, Omax) * wicketFactor(w) * 100;
    return Math.max(0, Math.min(100, r));
  }
  function totalAvailableAtStart(matchType){
    var Omax = (matchType === 't20') ? 20 : 50;
    return resource(matchType, Omax, 0);
  }
  global.DLSResources = { resource: resource, totalAvailableAtStart: totalAvailableAtStart };
})(window);
