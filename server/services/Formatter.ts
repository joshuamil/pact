'use strict';

const _ = require('lodash');

export default class Formatter {

  constructor() {

  }

  // Formats the output as an array of string values
  recordValuesArray(results: any, attribute: string) {
    return _.map(results, attribute);
  }

  // Default output format for the API. Returns attributes to assist with record
  // pagination and filtering
  public recordCollection(results: any, filter: any = {}) {
    // Define the limit and offset
    let limit: number = 0;
    let offset: number = 0;

    if (filter && filter.offset) {
      offset = parseInt(filter.offset, 10);
    }

    // Run the manual record limit if defined in the filter
    if (filter && filter.hasOwnProperty('softLimit') && parseInt(filter.softLimit, 10) > 0) {
      limit = parseInt(filter.softLimit, 10);
      results = this.limitRecords(results, limit, offset);
    } else if (filter && filter.limit) {
      limit = parseInt(filter.limit, 10);
    }

    // Format the output
    let output: any = {
      total: results.length,
      limit: limit,
      offset: offset,
      data: results
    };

    return output;
  }

  // Force camelCase Response by recursively cascading
  //into the results
  public camelCase(results: any) {
    let newAttribute: string;
    let thisRow: any;
    let newRow: any;
    let newResults: any = [];
    let records: any = results.data || results;

    // Update the object with the transformed data
    let returnData = () => {

      // Ensure the length still matches
      if (results.hasOwnProperty('total')) {
        results.total = results.data.length;
      }

      // Return the new results into the correct data node
      if (results.hasOwnProperty('data')) {
        results.data = newResults;
      } else {
        results = newResults;
      }

      return results;
    };

    // Performs camelCase transformation
    let setColumnName = (input: string) => {
      return input.substr(0, 1).toLowerCase() + input.substr(1, (input.length - 1));
    };

    // Parse values into newly named attributes; if objects/arrays, recursively parse
    let parseValues = (thisRow: any, column: string, newResults: any) => {
      let currentValue: any;
      let newAttribute: string = setColumnName(column);
      // Recurse into each object
      if (
        (typeof thisRow[column] === 'object' && thisRow[column] !== null) ||
        (Array.isArray(thisRow[column]))
      ) {
        currentValue = assignObject(thisRow[column]);
        newResults[newAttribute] = this.camelCase(currentValue);
      } else if (thisRow[column] !== null) {
        // Parse simple values
        newResults[newAttribute] = this.camelCase(thisRow[column]);
      } else {
        // Null and other uncaught values
        newResults[newAttribute] = thisRow[column];
      }
    };

    // Assign object value, checkint for Sequelize objects in the process
    let assignObject = (object: any) => {
      let thisRow: any;
      try {
        thisRow = object.get();
      }
      catch(err) {
        thisRow = object;
      }
      return thisRow;
    };

    if (Array.isArray(records)) {

      // If the value is an array, then iterate through the collection
      records.forEach( (row: any) => {
        newRow = {};
        thisRow = assignObject(row);
        for (let column in thisRow) {
          parseValues(thisRow, column, newRow);
        }
        newResults.push(newRow);
      });

      // Set the new results
      returnData();

    } else if (typeof records === 'object' && records !== null &&
      typeof records.getMonth !== 'function') {

      // If the value is an object, but not a date, then iterate through the keys
      newResults = {};
      thisRow = assignObject(records);
      for (let column in thisRow) {
        parseValues(thisRow, column, newResults);
      }

      // Set the new results
      returnData();

    } else {

      //console.log('Edge case???');
      //console.log(records);

    }

    return results;
  }

  // Slices a recordset into a smaller chunk for when the Sequelize limit feature
  // proves too buggy.
  private limitRecords(data: any, limit: number, offset: number) {
    let results: any;
    results = data.slice(offset, (offset+limit));
    return results;
  }

}
