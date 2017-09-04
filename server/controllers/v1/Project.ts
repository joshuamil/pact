/**
 * This controller handles the interaction of the API route and the data model
 * for "WorkOrder". Actions here meant to be handled directly by RESTful requests
 * that initiate via the associated route. Each REST verb should have a related
 * action in this file (e.g.: GET = list / retrieve, POST = create, PUT = update,
 * PATCH = modify, etc.)
 *
 */

'use strict';
import BaseController from "../Base";
import ProjectService from '../../services/v1/Project';

export default class ProjectController extends BaseController {

  constructor() {
    super();
    this.service = new ProjectService();
  }

  protected getModel(): string {
    return 'Project';
  }

  create(req: any, res: any) {
    let payload: any = this.service.parseRequestBody(req, true);
    return super.create(req, res, payload);
  }

  update(req: any, res: any) {
    let payload: any = this.service.parseRequestBody(req, false);
    return super.update(req, res, payload);
  }

}
