using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Text;
using System.Threading.Tasks;
using PDU_Web_Editor.DAL;
using PDU_Web_Editor.DAL.Interface;


namespace PDUWebEditorUnitTestProject.DAL.Infrastructure
{
    class InMemoryRepositoryBase<TEntity> : IRepository<TEntity> where TEntity : class, IEntity
    {
        private List<TEntity> context;

        public InMemoryRepositoryBase()
        {
            this.context = new List<TEntity>();
        }

        #region IRepository<TEntity> Members

        public void Insert(TEntity entity)
        {
            context.Add(entity);
        }

        public void Update(TEntity entityToUpdate)
        {
            if (context.Contains(entityToUpdate))
            {
                context.Remove(entityToUpdate);
                context.Add(entityToUpdate);
            }
        }

        public void Delete(TEntity entityToDelete)
        {
            Delete(entityToDelete.Id);
        }

        public void Delete(object id)
        {
            int index = context.FindIndex(o => o.Id == id.ToString());
            context.RemoveAt(index);
        }

        public TEntity GetByID(object id)
        {
            return context.Find(o => o.Id == id.ToString());
        }

        public IEnumerable<TEntity> Get(System.Linq.Expressions.Expression<Func<TEntity, bool>> filter = null, Func<IQueryable<TEntity>, IOrderedQueryable<TEntity>> orderBy = null, string includeProperties = "")
        {
  
             IQueryable<TEntity> query = this.context.AsQueryable<TEntity>();
           

             if (filter != null)
             {
                 query = query.Where(filter);
             }

             foreach (var includeProperty in includeProperties.Split
                 (new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
             {
                 query = query.Include(includeProperty);
             }

             if (orderBy != null)
             {
                 return orderBy(query).ToList();
             }
             else
             {
                 return query.ToList();
             }
        }

        public void Save()
        {
           //do nothing
        }

        #endregion

        #region IDisposable Members

        public void Dispose()
        {
            //do nothing
        }

        #endregion
    }
}


