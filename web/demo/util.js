function parseQCNInput(input) {
    let edges = input.trim().split("\n");
    let graphvizString = "digraph G {\n";
    let aspString = "";
    
    edges.forEach(line => {
        let match = line.match(/(\d+)\s+(\d+)\s+\(([^)]+)\)/);
        if (match) {
            let from = match[1];
            let to = match[2];
            let labels = match[3].split(/\s+/);
            labels = labels.filter(label => label.trim() !== "");
            
            graphvizString += `  ${from} -> ${to} [label=\"${labels.join(" ")}\"]\n`;
            aspString += `constraint(${from}, ${to}, (${labels.join(";")})).\n`;
        }
    });
    
    graphvizString += "}";
    return { graphvizString, aspString };
}


async function solveQCN(aspSting) {

    const satisfyEncoding = `
    {relation(FROM,TO,RELATION): baserelation(TYPE,RELATION)} = 1:- edge((FROM,TO)).
    :- relation(FROM,OVER,R1), relation(OVER,TO,R2), relation(FROM,TO,R3), not composition(TYPE,R1,R2,R3), baserelation(TYPE,_).
    :- relation(FROM,TO,REL), not constraint(FROM,TO,REL), constraint(FROM,TO,_), not ab((FROM,TO)).
    `;

    const graphCompletion = `
    edge((FROM,TO)) :- constraint(FROM,TO,_).
    node(NODE) :- edge((_,NODE)).
    node(NODE) :- edge((NODE,_)).
    edge((FROM,TO)) :- node(FROM), node(TO), FROM < TO.
    `;

    const allenIntervalAlgebra = `
    % INTERVAL ALGEBRA
    baserelation(allen,(eq;b;bi;d;di;o;oi;m;mi;s;si;f;fi)).
    composition(allen,eq,eq,eq).
    composition(allen,eq,b,b).
    composition(allen,eq,bi,bi).
    composition(allen,eq,d,d).
    composition(allen,eq,di,di).
    composition(allen,eq,o,o).
    composition(allen,eq,oi,oi).
    composition(allen,eq,m,m).
    composition(allen,eq,mi,mi).
    composition(allen,eq,s,s).
    composition(allen,eq,si,si).
    composition(allen,eq,f,f).
    composition(allen,eq,fi,fi).
    composition(allen,b,eq,b).
    composition(allen,b,b,b).
    composition(allen,b,bi,(eq;b;bi;d;di;o;oi;m;mi;s;si;f;fi)).
    composition(allen,b,d,(b;o;m;d;s)).
    composition(allen,b,di,b).
    composition(allen,b,o,b).
    composition(allen,b,oi,(b;o;m;d;s)).
    composition(allen,b,m,b).
    composition(allen,b,mi,(b;o;m;d;s)).
    composition(allen,b,s,b).
    composition(allen,b,si,b).
    composition(allen,b,f,(b;o;m;d;s)).
    composition(allen,b,fi,b).
    composition(allen,bi,eq,bi).
    composition(allen,bi,b,(eq;b;bi;d;di;o;oi;m;mi;s;si;f;fi)).
    composition(allen,bi,bi,bi).
    composition(allen,bi,d,(bi;oi;mi;d;f)).
    composition(allen,bi,di,bi).
    composition(allen,bi,o,(bi;oi;mi;d;f)).
    composition(allen,bi,oi,bi).
    composition(allen,bi,m,(bi;oi;mi;d;f)).
    composition(allen,bi,mi,bi).
    composition(allen,bi,s,(bi;oi;mi;d;f)).
    composition(allen,bi,si,bi).
    composition(allen,bi,f,bi).
    composition(allen,bi,fi,bi).
    composition(allen,d,eq,d).
    composition(allen,d,b,b).
    composition(allen,d,bi,bi).
    composition(allen,d,d,d).
    composition(allen,d,di,(eq;b;bi;d;di;o;oi;m;mi;s;si;f;fi)).
    composition(allen,d,o,(b;o;m;d;s)).
    composition(allen,d,oi,(bi;oi;mi;d;f)).
    composition(allen,d,m,b).
    composition(allen,d,mi,bi).
    composition(allen,d,s,d).
    composition(allen,d,si,(bi;oi;mi;d;f)).
    composition(allen,d,f,d).
    composition(allen,d,fi,(b;o;m;d;s)).
    composition(allen,di,eq,di).
    composition(allen,di,b,(b;o;m;di;fi)).
    composition(allen,di,bi,(bi;oi;di;mi;si)).
    composition(allen,di,d,(o;oi;d;di;eq;s;si;f;fi)).
    composition(allen,di,di,di).
    composition(allen,di,o,(o;di;fi)).
    composition(allen,di,oi,(oi;di;si)).
    composition(allen,di,m,(o;di;fi)).
    composition(allen,di,mi,(oi;di;si)).
    composition(allen,di,s,(o;di;fi)).
    composition(allen,di,si,di).
    composition(allen,di,f,(oi;di;si)).
    composition(allen,di,fi,di).
    composition(allen,o,eq,o).
    composition(allen,o,b,b).
    composition(allen,o,bi,(bi;oi;di;mi;si)).
    composition(allen,o,d,(o;d;s)).
    composition(allen,o,di,(b;o;m;di;fi)).
    composition(allen,o,o,(b;o;m)).
    composition(allen,o,oi,(o;oi;d;di;eq;s;si;f;fi)).
    composition(allen,o,m,b).
    composition(allen,o,mi,(oi;di;si)).
    composition(allen,o,s,o).
    composition(allen,o,si,(o;di;fi)).
    composition(allen,o,f,(o;d;s)).
    composition(allen,o,fi,(b;o;m)).
    composition(allen,oi,eq,oi).
    composition(allen,oi,b,(b;o;m;di;fi)).
    composition(allen,oi,bi,bi).
    composition(allen,oi,d,(oi;d;f)).
    composition(allen,oi,di,(bi;oi;di;mi;si)).
    composition(allen,oi,o,(o;oi;d;di;eq;s;si;f;fi)).
    composition(allen,oi,oi,(bi;oi;mi)).
    composition(allen,oi,m,(o;di;fi)).
    composition(allen,oi,mi,bi).
    composition(allen,oi,s,(oi;d;f)).
    composition(allen,oi,si,(bi;oi;mi)).
    composition(allen,oi,f,oi).
    composition(allen,oi,fi,(oi;di;si)).
    composition(allen,m,eq,m).
    composition(allen,m,b,b).
    composition(allen,m,bi,(bi;oi;di;mi;si)).
    composition(allen,m,d,(o;d;s)).
    composition(allen,m,di,b).
    composition(allen,m,o,b).
    composition(allen,m,oi,(o;d;s)).
    composition(allen,m,m,b).
    composition(allen,m,mi,(f;fi;eq)).
    composition(allen,m,s,m).
    composition(allen,m,si,m).
    composition(allen,m,f,(o;d;s)).
    composition(allen,m,fi,b).
    composition(allen,mi,eq,mi).
    composition(allen,mi,b,(b;o;m;di;fi)).
    composition(allen,mi,bi,bi).
    composition(allen,mi,d,(oi;d;f)).
    composition(allen,mi,di,bi).
    composition(allen,mi,o,(oi;d;f)).
    composition(allen,mi,oi,bi).
    composition(allen,mi,m,(s;si;eq)).
    composition(allen,mi,mi,bi).
    composition(allen,mi,s,(oi;d;f)).
    composition(allen,mi,si,bi).
    composition(allen,mi,f,mi).
    composition(allen,mi,fi,mi).
    composition(allen,s,eq,s).
    composition(allen,s,b,b).
    composition(allen,s,bi,bi).
    composition(allen,s,d,d).
    composition(allen,s,di,(b;o;m;di;fi)).
    composition(allen,s,o,(b;o;m)).
    composition(allen,s,oi,(oi;d;f)).
    composition(allen,s,m,b).
    composition(allen,s,mi,mi).
    composition(allen,s,s,s).
    composition(allen,s,si,(s;si;eq)).
    composition(allen,s,f,d).
    composition(allen,s,fi,(b;o;m)).
    composition(allen,si,eq,si).
    composition(allen,si,b,(b;o;m;di;fi)).
    composition(allen,si,bi,bi).
    composition(allen,si,d,(oi;d;f)).
    composition(allen,si,di,di).
    composition(allen,si,o,(o;di;fi)).
    composition(allen,si,oi,oi).
    composition(allen,si,m,(o;di;fi)).
    composition(allen,si,mi,mi).
    composition(allen,si,s,(s;si;eq)).
    composition(allen,si,si,si).
    composition(allen,si,f,oi).
    composition(allen,si,fi,di).
    composition(allen,f,eq,f).
    composition(allen,f,b,b).
    composition(allen,f,bi,bi).
    composition(allen,f,d,d).
    composition(allen,f,di,(bi;oi;di;mi;si)).
    composition(allen,f,o,(o;d;s)).
    composition(allen,f,oi,(bi;oi;mi)).
    composition(allen,f,m,m).
    composition(allen,f,mi,bi).
    composition(allen,f,s,d).
    composition(allen,f,si,(bi;oi;mi)).
    composition(allen,f,f,f).
    composition(allen,f,fi,(f;fi;eq))	.
    composition(allen,fi,eq,fi).
    composition(allen,fi,b,b).
    composition(allen,fi,bi,(bi;oi;di;mi;si)).
    composition(allen,fi,d,(o;d;s)).
    composition(allen,fi,di,di).
    composition(allen,fi,o,o).
    composition(allen,fi,oi,(oi;si;di)).
    composition(allen,fi,m,m).
    composition(allen,fi,mi,(oi;si;di)).
    composition(allen,fi,s,o).
    composition(allen,fi,si,di).
    composition(allen,fi,f,(f;fi;eq)).
    composition(allen,fi,fi,fi).
    `;

    const directives = `
    #show relation/3.
    `;

    await clingo.init("https://cdn.jsdelivr.net/npm/clingo-wasm@0.1.0/dist/clingo.wasm");
    const clingoResult = await clingo.run(allenIntervalAlgebra +"\n"+ satisfyEncoding +"\n"+ graphCompletion +"\n"+ aspSting +"\n"+ directives, 100);
    return clingoResult;
}