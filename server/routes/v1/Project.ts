/**
 * This route defines the CRUD operations for a given route in the API.
 * Each entity you wish to interact with inside of Daymon  should have a
 * corresponding route file structured like this.
 *
 */

'use strict';

//import ContainerWrapper from '../../di/Container';
import * as express from "express";
let router = express.Router();

import Project from "../../controllers/v1/Project";
let routeController = new Project();

import BaseRouter from "../Base";
let baseRouter = new BaseRouter();

router = baseRouter.enableRoutes(routeController);

module.exports = router;
