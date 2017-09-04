const pg = require('pg');
const fs = require('fs');
const path = require('path');

// If no environment variable exists, try using defalt, local instance
if (!process.env.hasOwnProperty('DB_URL')) {
  process.env.DB_URL = 'postgres://admin:@localhost:5432/pact';
}

const client = new pg.Client(process.env.DB_URL);
const dirSql = path.join(__dirname + '/sql/');
let statement = '';

client.connect((err) => {
  if (err) throw err;

  console.log('Database seeding started ...');

  let count = 0;
  let filesInDirectory = fs.readdirSync(dirSql);

  filesInDirectory.forEach( (file, index) => {
    if (file.substr(0, 1) !== '_') {
      count++;
    }
  });

  // Read the file system and iterate over results
  filesInDirectory.forEach((file, index, files) => {

    // Exclude files prefixed with underscore "_" as these are temporary
    // files that are being used to manually populate the seeder scripts
    if (file.substr(0, 1) !== '_') {

      // Extract the query statement from the file
      statement = fs.readFileSync(dirSql + file, 'utf8');

      // Execute the query statement
      client.query(statement, (err, result) => {
        if (err) {
          console.log(` - Running scripts for ${file}`);
          console.error(statement);
          throw err;
        }

        console.log(` - Running scripts for ${file}`);

        // Close the connection on the last cycle
        if (index === (count-1)) {
          client.end((err) => {

            console.log('Database seeding complete.');

            if (err) {
              console.error(err);
              process.exit(1);
            } else {
              process.exit();
            }
          });
        }

      });

    }

  });

});

// Handle client error
client.on('error', (err) => {
  console.error(err);
  process.exit(1);
});
