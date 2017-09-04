'use strict';

import * as express from "express";

export default class FoundationRouter {

  router: any;
  constructor() {
    this.router = express.Router();
  }

  initRoutes() {

    // Global actions for the this route
    this.router.use(function(req: any, res: any, next: any) {
      next();
    });


    // Options Operations - required for CORS XHR requests
    this.router.options(['/', '/:id'], function(req: any, res: any) {
      res.header('Access-Control-Allow-Origin', '*');
      res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS');
      res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, Content-Length, X-Requested-With');
      res.status(200).send({});
    });

    return this.router;

  }

}
