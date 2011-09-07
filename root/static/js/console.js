try { console.debug(); } catch(e) { console = { debug: function(){}, log: function(){} } }
