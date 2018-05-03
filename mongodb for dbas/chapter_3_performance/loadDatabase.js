var imax = 32;
var jmax = 32;
var kmax = 1000;

function setValues(doc, i, j, k) { 
    doc._id = jmax * kmax * i + kmax * j + k;
    doc.a = i;
    doc.b = j;
    doc.c = k;
}

var emptyString = 'asdf';
emptyString = emptyString.pad(1000);  // make it bigger.
// make one thousand copies of our document in an array.
listOfDocs = []
for (i=0; i<kmax; i++) {
    listOfDocs.push({ _id: 0, a: 0, b : 0, c : 0, d : emptyString });
};
// one_thousand_docs is now built.


db.dropDatabase();  // start with a clean slate.
// db.createCollection("foo", {noPadding: true})
for (i=0; i<imax; i++) {
    for(j=0; j<jmax; j++) {
        for (k=0; k<1000; k++) {
            setValues(listOfDocs[k], i, j, k)
        };
        db.foo.insert(listOfDocs)  // breaks up if larger than 1000.
    }
}
