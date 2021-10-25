import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
admin.initializeApp(functions.config().firebase);


export const onNewPesquisa = functions.firestore.document("/Empresas/ucw9UDV1tiewVkTocANqK4YXgim2/pesquisasCriadas/{pesquisaID}").onCreate(async (snapshot, context) => {
    
    const idPromotor = snapshot.get('idPromotor');
    const nomeLoja = snapshot.get('nomeLoja');
    const nomePromotor = snapshot.get('nomeLoja');

    await sendPushFCM(
        idPromotor,
        nomePromotor + ', você tem uma nova pesquisa.',
        'Loja: '+ nomeLoja
    );
});


async function sendPushFCM(topic: string, title: string, message: string){
    if(1> 0){
        const payload = {
            notification: {
                title: title,
                body: message,
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
                sound: 'default'
                
            }
            

        };
        return admin.messaging().sendToTopic(topic, payload);
    }
    return;
}
