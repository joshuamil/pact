'use strict';
import * as moment from "moment";
import BaseService from "../Base";
import Filter from '../Filter';
const Models = require('../../models')('v1');

export default class ProjectService extends BaseService {

  model: any;
  defaultFilter: any;

  constructor() {
    super();
    this.models = Models;
    this.model = this.models[this.getModelName()];
    this.filter = new Filter();
  }

  protected getModelName():string {
    return "Project";
  }
}
