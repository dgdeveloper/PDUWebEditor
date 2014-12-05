using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace PDU_Web_Editor.DAL
{
    public interface IRepository<TEntity> : IDisposable where TEntity : class 
    {
        /// <summary>
        /// Add entity to the repository 
        /// </summary>
        /// <param name="entity">the entity to add</param>
        void Insert(TEntity entity);

        /// <summary>
        /// Updates entity within the repository
        /// </summary>
        /// <param name="entityToUpdate">the entity to update</param>
        void Update(TEntity entityToUpdate);

        /// <summary>
        /// Delete entity within the repository
        /// </summary>
        /// <param name="entityToDelete">the entity to be deleted</param>
        void Delete(TEntity entityToDelete);

        /// <summary>
        /// Delete entity within the  repository by its unique id
        /// </summary>
        /// <param name="id"> unique id of the entity</param>
        void Delete(object id);

        /// <summary>
        /// Get a selected entity by its unique id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        TEntity GetByID(object id);

        /// <summary>
        /// Load the entities using a linq expression filter
        /// </summary>
        /// <param name="filter">linq expression filte</param>
        /// <returns>the loaded entity</returns>
        IEnumerable<TEntity> Get(
           Expression<Func<TEntity, bool>> filter = null,
           Func<IQueryable<TEntity>, IOrderedQueryable<TEntity>> orderBy = null,
           string includeProperties = "");
        /// <summary>
        /// Save the change to the database
        /// </summary>
        void Save();
    }
}
