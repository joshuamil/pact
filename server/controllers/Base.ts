/**
 * This controller handles the basic interactions between a data model and a route.
 *
 */

'use strict';

import * as moment from "moment";
import BaseService from '../services/Base';
import Formatter from '../services/Formatter';
import Error from '../services/Error';
const Models = require('../models')('v1');

export default abstract class BaseController {

  models: any;
  model: any;
  error: any;
  filter: any;
  key: string;
  protected service:any;
  formatter: any;

  constructor() {
    const name = this.getModel();
    this.model = Models[name];
    this.models = Models;
    this.filter = {};
    this.error = new Error();
    this.formatter = new Formatter();
    this.service = new BaseService();
  }

  protected abstract getModel(): string;

  // Returns messages to the browser
  protected response(res: any, message: any, httpStatusCode: number = 200) {
    res.status(httpStatusCode).send(message);
  }


  // Returns failure messages to the browser
  protected failure(res: any, error: any, httpStatusCode: number = 404) {
    let err: any = this.error.handleError(error, httpStatusCode);
    return this.response(res, err, err.status);
  }


  // Performs a basic POST operation
  create(req: any, res: any, payload: any) {
    return this.service.create(req, res, payload)
      .then( (results: any) => {
        return this.response(res, results, 201);
      })
      .catch( (error: any) => {
        return this.failure(res, error, error.status);
      });
  }


  // Performs a basic DELETE operation with an ID parameter
  delete(req: any, res: any) {
    return this.service.delete(req, res, this.filter)
      .then( (results: any) => {
        return this.response(res, results);
      })
      .catch( (error: any) => {
        return this.failure(res, error, error.status);
      });
  }


  // Performs the basic GET operation
  list(req: any, res: any) {
    // Find all matches based on modified filter
    return this.service.list(req, res, this.filter)
      .then( (results: any) => {
        return this.response(res, results);
      })
      .catch( (error: any) => {
        return this.failure(res, error, error.status);
      });
  }


  // Performs the basic GET operation that returns only the declared values in an array
  listValues(req: any, res: any) {
    // TODO: Get this working again
    let att: string = '';
    if (req.params.attribute) {
      att = req.params.attribute;
    }
    return this.service.listValues(req, res, this.filter)
      .then( (results: any) => {
        return this.response(res, results);
      })
      .catch( (error: any) => {
        return this.failure(res, error, error.status);
      });
  }


  // Performs a basic PATCH operation with an ID parameter
  patch(req: any, res: any, payload: any) {
    return this.service.update(req, res, payload, this.filter)
      .then( (results: any) => {
        return this.response(res, results);
      })
      .catch( (error: any) => {
        return this.failure(res, error, error.status);
      });
  }


  // Performs the basic GET operation with an ID parameter
  retrieve(req: any, res: any) {
    return this.service.retrieve(req, res, this.filter)
      .then( (results: any) => {
        return this.response(res, results);
      })
      .catch( (error: any) => {
        return this.failure(res, error, error.status);
      });
  }


  // Performs the basic PUT operation with an ID parameter
  update(req: any, res: any, payload: any) {
    return this.service.update(req, res, payload, this.filter)
      .then( (results: any) => {
        return this.response(res, results);
      })
      .catch( (error: any) => {
        return this.failure(res, error, error.status);
      });
  }


  //TODO: Placing it in the BaseController since other controllers may need it.
  //Will ultimately be moved to a Util/service layer once that's in place.
  protected convertToAttribNames(model: any) {
    const attribs = [];

    for (let attrib in model.tableAttributes) {
      attribs.push(attrib);
    }

    return attribs;
  }


}
