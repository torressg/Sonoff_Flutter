require('dotenv').config();
const ewelink = require('ewelink-api');

// ACCESS WELINK
const email = process.env.EMAIL_WELINK;
const password = process.env.PASSWORD_WELINK;
const region = process.env.REGION_WELINK;
const appid = process.env.APPID_WELINK;
const appsecret = process.env.APPSECRET_WELINK;
const deviceID = '1000ba1e43';

async function createConnection() {
    return await new ewelink({
        email: email,
        password: password,
        region: region,
        APP_ID: appid,
        APP_SECRET: appsecret
    });
}

async function changeSwitch(connection, Luz) {
    await connection.setDevicePowerState(deviceID, 'toggle', Luz);
}
(async () => {

    const connection = await createConnection();

    // Acende ou apaga a luz
    const Luz = {
        'Central': '1',
        'Armário': '2',
        'Janela': '3'
    }

    await changeSwitch(connection, Luz.Central)


    // Retorna Status das Luzes
    let status = await connection.getDevice(deviceID)
    status = status.params.switches
    status.forEach((OnOrOff) => {
        if (OnOrOff.outlet == '0') {
            if (OnOrOff.switch == 'on') {
                console.log('Luz Central está ligada.')
            } else {
                console.log('Luz Central está desligada.')
            }
        } else if (OnOrOff.outlet == '1') {
            if (OnOrOff.switch == 'on') {
                console.log('Luz Armário está ligada.')
            } else {
                console.log('Luz Armário está desligada.')
            }
        } else if (OnOrOff.outlet == '2') {
            if (OnOrOff.switch == 'on') {
                console.log('Luz Janela está ligada.')
            } else {
                console.log('Luz Janela está desligada.')
            }
        } else {

        }
    });
    /*
    swiches:  [
        { switch: 'on', outlet: 0 }, central
        { switch: 'on', outlet: 1 }, janela
        { switch: 'on', outlet: 2 }, armario
        { switch: 'off', outlet: 3 }
      ]
    */
})();