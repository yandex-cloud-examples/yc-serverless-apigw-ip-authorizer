exports.handler = async function (event, context) {
    let allowFromIP = process.env.ALLOW_FROM_IP;

    // Request path including possible proxies chain between end user and API Gateway
    let forwardedForIPs = event.headers["X-Forwarded-For"].split(',');

    // Last address in X-Forwarded-For header is guaranteed to belong to machine connected to API Gateway
    let remoteIP = forwardedForIPs[forwardedForIPs.length - 1].trim();

    if (remoteIP === allowFromIP) {
        return {
            "isAuthorized": true,
        };
    }
    console.log("Access denied for ip: " + remoteIP);

    return {
        "isAuthorized": false
    };
};