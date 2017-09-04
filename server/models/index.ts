'use strict';

const fs = require('fs');
const path = require('path');
const Sequelize = require('sequelize');
const basename = path.basename(module.filename);
const env = process.env.NODE_ENV || 'local';
const config = require(__dirname + '/../configs/sequelize.json')[env];
let db: any;
let invocations:number = 0;

import * as _ from "lodash";

// Create connection to sequelize
let sequelize: any;
if (_.has(config, 'use_env_variable') && _.has(process.env, config.use_env_variable)) {
  sequelize = new Sequelize(process.env[config.use_env_variable], config.options);
} else if (_.has(config, 'uri')) {
  sequelize = new Sequelize(config.uri, config.options);
} else {
  sequelize = new Sequelize(config.database, config.username, config.password, config.options);
}

module.exports = function(version: string) {
  invocations++;

  //Sequelize is getting initialized twice on server bootstrap. I haven't yet been able to figure
  //out as to why. The associate() method is therfore invoked twice. The second time around
  //the aliases in the associations are failing as they are already defined.
  //The below code ensures that the sequelize models are only defined once.
  if(db) {
    return db;
  }

  db = {}

  // Default version if unspecified
  version = version || 'v1';

  // Read the models directory and create appropriate models
  fs
    .readdirSync(__dirname + `/${version}/`)
    .filter((file: string) =>
      (file.indexOf('.') !== 0) &&
      (file !== basename) &&
      (file.slice(-3) === '.ts'))
    .forEach((file: string) => {
      const model = sequelize.import(path.join(__dirname + `/${version}/`, file));
      db[model.name] = model;
    });

  // Enable associations / relationships between models
  Object.keys(db).forEach((modelName: any) => {
    if (db[modelName].associate) {
      db[modelName].associate(db);
    }
  });

  db.sequelize = sequelize;
  db.Sequelize = Sequelize;

  return db;
}
