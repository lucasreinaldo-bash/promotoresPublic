import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
admin.initializeApp(functions.config().firebase);


export const onNovaPesquisa = functions.firestore.document("/Promotores/{promotorID}/PesquisasRecebidas/{pesquisaID}").onCreate(async (snapshot, context) => {
    
   
    
   
});

