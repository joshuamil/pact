import * as express from "express";

/**
 * This class bootstraps the application. The bootstrap code has been made reusable so that
 * it may be invoked from index.js (when runing the main code) or when running integration
 * tests.
 */
class Bootstrap {

    public static startApp():void {
        const logger = require('morgan');
        const bodyParser = require('body-parser');
        const app = express();

        // Log requests to the console
        app.use(logger('dev'));

        // Parse incoming requests
        app.use(bodyParser.json());
        app.use(bodyParser.urlencoded({ extended: true }));

        app.use(function(req: any, res: any, next: any) {
            res.header("Access-Control-Allow-Origin", "*");
            res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
            next();
        });

        Bootstrap.configureRoutes(app);
    }

    private static configureRoutes(app: express.Application):void {
        //TODO: Remove unused code picked up from index.ts
        //May be reused. Hence not removed
        // Define base API route handler
        /* Currently unused
        app.all(`${settings.server.basePath}/:version/:operation`, function (req, res, next) {
        // Handle lookup of client, authentication token, rate limits, etc.
        console.log(`Invoking route: ${req.params.version}/${req.params.operation}`);
        next();
        });
        */

        const routes = require('../configs/routes.json');
        const path = require('path');

        // Enable static routes
        app.use('/', express.static(path.join(__dirname, '../../public')));
        app.use('/swagger', express.static(path.join(__dirname, '../configs')));

        // Get application settings
        const settings = require('../configs/app.json');

        // Load custom external routes
        let routers: any = {};
        routes.forEach((rte: any) => {
            try {
                routers[rte.name] = require(`../routes/${rte.version}${rte.path}`);
                app.use(`${settings.server.basePath}/${rte.version}${rte.path}`, routers[rte.name]);
                console.log(`Route enabled: ${rte.name}`);
            } catch (e) {
                console.log(`Route missing: ${rte.name}`);
                console.log(e);
            }
        });

        // Initialize the server
        app.listen(settings.server.port, function () {
            console.log(`Running on port: ${settings.server.port}`);
        });
    }

}

export default Bootstrap;
