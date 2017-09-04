'use strict';

export default class Filter {

  constructor() {

  }


  // Sets filter options based on URL parameters
  setOptions(filter: any = {}, req: any, options: any = {}) {
    let col: Array<string>;
    let orderby: any = [];
    let model: string;
    let preserve: boolean = false;

    if (!filter) {
      filter = {};
    }

    if (options.hasOwnProperty('preserveFilter') && options.preserveFilter) {
      // Don't delete the filter options
      preserve = true;
    } else {
      delete filter.limit;
      delete filter.offset;
      delete filter.order;
      delete filter.where;
      delete filter.attributes;

      // Clear where filters
      this.clearIncludedModelWhere(filter);

    }


    // Pre-seed the filter
    if (options.hasOwnProperty('baseFilter')) {
      filter = options.baseFilter;
    }

    // We're not always using the default model, so make it an option
    if (options.hasOwnProperty('model')) {
      model = options.model;
    }

    // Override filter attributes with query attributes
    if (req.query.attributes) {
      filter.attributes = req.query.attributes;
    }

    // Add limits to filter
    // KNOWN ISSUE: Limit causes some problems with more complex queries as the
    // LIMIT feature gets thrown into a subquery that then changes the naming
    // conventions of remaining tables. In some cases, we want to ignore it
    // altogether.
    if (options.hasOwnProperty('noLimit') && options.noLimit) {
      if (filter.limit) {
        delete filter.limit;
      }
    } else if (req.query.limit && parseInt(req.query.limit, 10) > 0) {
      filter.limit = req.query.limit;
    } else if (filter.limit && !preserve) {
      delete filter.limit;
    }

    // Add offsets to filter
    if (req.query.offset && parseInt(req.query.offset, 10) > 0) {
      filter.offset = req.query.offset;
    } else if (filter.offset && !preserve) {
      delete filter.offset;
    }

    // Add custom ordering to filter
    if (req.query.order) {
      filter.order = [];
      orderby = req.query.order.split(',');
      orderby.forEach((item: any) => {
        col = item.split(':');
        filter.order.push(col);
      });
    } else if (filter.order && !preserve) {
      delete filter.order;
    }

    // Parse search query params
    if (req.query.search) {
      filter = this.searchFilter(filter, req);
    }

    // Parse foreign key lookup
    if (req.params.key && req.params.value) {
      this.relationalFilter(filter, req);
    }

    return filter;
  }


  // Sets the base filter where clause to use the [Name]ID parameter
  setFilter(filter: any = {}, key: string, req: any) {
    this.setOptions(filter, req);
    this.whereFilter(filter, key, req.params.id, 'eq');
    return filter;
  }


  // Sets the base filter to use the foreign key and value specified in the path
  relationalFilter(filter: any = {}, req: any) {
    this.whereFilter(filter, req.params.key, req.params.value, 'eq');
    return filter;
  }


  // Returns the filter properties for a given include
  getIncludedModelByName(filter: any = {}, name: string) {
    let item: number = -1;
    if (filter.hasOwnProperty('include') && Array.isArray(filter.include)) {
      filter.include.forEach((entry: any, index: number) => {
        if (entry.model.tableName === name) {
          item = index;
        }
      });
      return filter.include[item];
    } else {
      return null;
    }
  }

  // Resets a model's where filter
  clearIncludedModelWhere(filter: any = {}) {
    let item: number = -1;
    if (filter && filter.hasOwnProperty('include')) {
      filter.include.forEach((entry: any) => {
        if (entry.hasOwnProperty('where')) {
          entry.where = {};
        }
      });
    }
    return filter;
  }


  // Sets the base filter to use the key/value passed in on the query string
  searchFilter(filter: any = {}, req: any) {

    let type: string = 'equals';
    let whereBy: Array<string> = [];

    // Reset the where filter
    filter.where = {};

    // Determine the type of search
    if (req.query.search.indexOf('{') > -1) {
      type = 'raw';
      filter.where = JSON.parse(req.query.search);
      return filter;
    }

    // Basic equals search
    else if (req.query.search.indexOf(':') > -1) {
      type = 'eq';
      whereBy = req.query.search.split(':');
    }

    // Not-like search
    else if (req.query.search.indexOf('!~') > -1) {
      type = 'notlike';
      whereBy = req.query.search.split('!~');
    }

    // Like search
    else if (req.query.search.indexOf('~') > -1) {
      type = 'like';
      whereBy = req.query.search.split('~');
    }

    // Not-equals search
    else if (req.query.search.indexOf('!') > -1) {
      type = 'neq';
      whereBy = req.query.search.split('!');
    }

    // If a search criteria is found, then continue
    if (whereBy.length > 0) {

      let key: string;
      let table: string = '';
      let value: string = whereBy[1];
      let join: Array<string> = whereBy[0].split('.');

      // Check to see if key uses dot-notation to denote a target source
      if (join.length > 1) {
        // Source table is declared
        table = join[0];
        key = join[1];
      } else {
        // No declared source table
        key = whereBy[0];
      }

      // Apply filter
      filter = this.whereFilter(filter, key, value, type, table);

    }

    return filter;

  }


  // Constructs a where filter
  whereFilter(filter: any = {}, key: string, value: string, type: string, table: string = '') {

    let newFilter: any = filter;

    // If a source table is defined, then find the model name
    if (table && table.length > 0) {
      newFilter = this.getIncludedModelByName(filter, table);
    }

    // If a filter is defined ...
    if (newFilter) {

      // Set an empty where filter
      if (!newFilter.hasOwnProperty('where')) {
        newFilter.where = {};
      }

      // Determine the type of filter and assign as appropriate
      if (type === 'eq') {
        newFilter.where[key] = value;
      } else if (type === 'like') {
        newFilter.where[key] = {"$like": `%${value}%`};
      } else if (type === 'neq') {
        newFilter.where[key] = {"$ne": `${value}`};
      } else if (type === 'notlike') {
        newFilter.where[key] = {"$notLike": `%${value}%`};
      }

      return filter;

    }

  }

}
