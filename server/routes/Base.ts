'use strict';

import * as express from "express";
import FoundationRouter from "./Foundation";

export default class BaseRouter extends FoundationRouter {

  router: any;
  constructor() {
    super();
    this.router = this.initRoutes();
  }

  enableRoutes(routeController: any) {

    // Create Operations
    this.router.post('/', function(req: any, res: any) {
      return routeController.create(req, res);
    });


    // Return simple value-response
    this.router.get(['/values/:attribute'], function(req: any, res: any) {
      return routeController.listValues(req, res);
    });


    // Query by specific columns/attributes/keys
    this.router.get([
      '/fk/:key/:value',
      '/by/:key/:value',
      '/key/:key/:value',
      '/where/:key/:value'
    ], function(req: any, res: any) {
      return routeController.list(req, res);
    });


    // Read Operations
    this.router.get('/', function(req: any, res: any) {
      return routeController.list(req, res);
    });

    this.router.get('/:id', function(req: any, res: any) {
      return routeController.retrieve(req, res);
    });


    // Update Operations
    this.router.put('/:id', function(req: any, res: any) {
      return routeController.update(req, res);
    });


    // Modify Operations
    this.router.patch('/:id', function(req: any, res: any) {
      return routeController.patch(req, res);
    });


    // Delete Operations
    this.router.delete('/:id', function(req: any, res: any) {
      return routeController.delete(req, res);
    });

    return this.router;

  }

}
