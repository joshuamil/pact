'use strict';

export default class Filter {

  constructor() {

  }

  // Handle database errors (500)
  private catchDatabaseError(error: any) {
    if (error.hasOwnProperty('name') && error.hasOwnProperty('parent') &&
      error.hasOwnProperty('sql')) {
      return {
        status: 500,
        error: error.name,
        details: error.parent.routine,
        message: 'An internal error was thrown while querying the database.'
      };
    } else {
      return false;
    }
  }

  // TODO: Create error handlers for other types
  // e.g.: catchFileError, catchTypeError, etc.

  // TODO: Create a more formal error handler that updates the status code
  // TODO: Support: 400, 401, 403, 404, 405, 500, 501, 502, 503, 504
  handleError(error: any, httpStatusCode: number = 500) {

    let isErrorType: any = false;

    // Base error
    let returnedError: any = {
      status: httpStatusCode,
      error: error,
      details: 'Unknown',
      message: 'An internal error has occurred.'
    };

    // Determine error type
    if (!isErrorType) {
      isErrorType = this.catchDatabaseError(error);
    }

    // Return the error if one is found
    if (typeof isErrorType === 'object') {
      returnedError = isErrorType;
    }

    // Pass request to error logger
    this.logError(returnedError);

    return returnedError;

  }

  // TODO: Log errors using some logging mechanism
  logError(error: any) {
    console.log('');
    console.error(error);
  }


}
