/**
 * This model reflects the structure of the associated database table or target
 * storage location. If you make modifications to your source table, they should
 * be reflected here as well.
 *
 * To protect this file from being overwritten by the generator, remove only the
 * exclamation mark (!) from the line below this comment.
 *
 */

// !PROTECTED

'use strict';

module.exports = function(sequelize: any, DataTypes: any) {

  var Project = sequelize.define('Project', {

      projectid: {
        type: DataTypes.INTEGER,
        allowNull: false,
        primaryKey: true,
        autoIncrement: true
      },
      name: {
        type: DataTypes.TEXT,
        allowNull: false
      },
      description: {
        type: DataTypes.TEXT,
        allowNull: false
      },
      abbrev: {
        type: DataTypes.TEXT,
        allowNull: false
      },
      startdate: {
        type: DataTypes.TIME,
        allowNull: true
      },
      enddate: {
        type: DataTypes.TIME,
        allowNull: true
      },
      deleted: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: false
      }
    },
    {
      freezeTableName: true,
      tableName: 'Project',
      defaultScope: {
        where: {
          deleted: false,
        },
      },
      scopes: {
        deleted: {
          where: {
            deleted: true,
          },
        },
        active: {
          where: {
            deleted: false,
          },
        },
      },
    }

  );

  // Associations
  Project.associate = function(models: any) {

  };

  Project.removeAttribute('id');
  Project.removeAttribute('createdAt');
  Project.removeAttribute('updatedAt');
  return Project;

};
