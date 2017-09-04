'use strict';

import Formatter from './Formatter';
import Filter from './Filter';
import Error from './Error';
import Fromatter from './Formatter';
const Models = require('../models')('v1');
const _ = require('lodash');

export default class BaseService {

  error: any;
  filter: any;
  formatter: any;
  model: any;
  models: any;
  key: string;
  private modelName: string = "";

  constructor() {
    if(this.getModelName() != "") {
      this.init();
    }
  }

  public init() {
    this.error = new Error();
    this.filter = new Filter();
    this.formatter = new Formatter();
    this.model = Models[this.getModelName()];
    this.models = Models;
    this.key = this.getKeyName(this.model, this.getModelName());
  }

  protected getModelName():string {
    return this.modelName;
  }

  public setModelName(modelName:string) {
    this.modelName = modelName;
  }

  // Returns the key name for the selected Model
  getKeyName(attributes: any, model: string) {
    if (attributes && attributes.hasOwnProperty('primaryKeyField')) {
      return this.model.primaryKeyField;
    }
    return `${model}ID`;
  }

  // List operation success
  list(req:any, res: any, filter: any = {}) {
    // Preserve filter options if flag is set
    let options: any = {};
    /*
    if (this.filter && this.filter.preserveFilter) {
      options.preserveFilter = this.filter.preserveFilter;
    }
    */
    filter = this.filter.setOptions(filter, req, options);
    return this.model
      .findAll(filter)
      .then((results: any) => {
        let output: any;
        if (req.params.output && req.params.output === 'simple') {
          output = results[0];
        } else {
          output = this.formatter.recordCollection(results, filter);
        }
        return this.success(output);
      })
      .catch((error: any) => {
        return this.failure(error);
      });
  }


  // Performs the basic GET operation that returns only the declared values in an array
  listValues(req: any, res: any, filter: any = {}) {
    this.filter.setOptions(filter, req);
    let att: string = '';
    if (req.params.attribute) {
      att = req.params.attribute;
    }
    return this.model
      .findAll(filter)
      .then((results: any) => {
        let output: any = this.formatter.recordValuesArray(results, att);
        return this.success(output);
      })
      .catch((error: any) => {
        return this.failure(error);
      });
  }


  // Retrieve operation success
  retrieve(req: any, res: any, filter: any = {}) {
    filter = this.filter.setFilter(filter, this.key, req);
    return this.model
      .findOne(filter)
      .then((results: any) => {
        let output: any;
        if (req.params.output && req.params.output === 'simple') {
          output = results[0];
        } else {
          output = results;
        }
        return this.success(results);
      })
      .catch((error: any) => {
        return this.failure(error);
      });

  }

  // Create operation success
  create(req: any, res: any, payload: any) {
    // TODO: Return Location header with URL to newly created entity
    // TODO: Return ETag with newly inserted Identity value
    return this.model
      .create(payload)
      .then((results: any) => {
        return this.success(results)
      })
      .catch((error: any) => {
        return this.failure(error);
      });
  }

  // Update operation success
  update(req: any, res: any, payload: any, filter: any = {}) {
    filter = this.filter.setFilter(filter, this.key, req);
    return this.model
      .update(payload, filter)
      .then((results: any) => {
        return this.success(results);
      })
      .catch((error: any) => {
        return this.failure(error);
      });
  }

  // Patch operation success
  patch(req: any, res: any, payload: any, filter: any = {}) {

    // Create a payload using the appropriate fields
    let keys: any = Object.keys(req.body);
    keys.forEach((field: string) => {
      if (req.body[field] !== null && field !== this.key) {
        payload[field] = req.body[field];
      }
    });

    return this.model
      .update(payload, this.filter)
      .then((results: any) => {
        return this.success(results);
      })
      .catch((error: any) => {
        return this.failure(error);
      });

  }

  // Delete operation success
  delete(req: any, res: any, filter: any) {
    filter = this.filter.setFilter(filter, this.key, req);
    return this.model
      .destroy(filter)
      .then((results: any) => {
        return this.success(results);
      })
      .catch((error: any) => {
        return this.failure(error);
      });

  }

  // Returns success messages to the browser
  success(results: any) {
    // Apply camelCase formatter to the output
    results = this.formatter.camelCase(results);
    // Return response to the consumer
    return results;
  }

  // Returns failure messages to the browser
  failure(error: any, httpStatusCode: number = 500) {
    return this.error.handleError(error, httpStatusCode);
  }

}
