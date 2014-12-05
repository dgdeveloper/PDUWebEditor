using PDU_Web_Editor.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Data.Entity.ModelConfiguration.Conventions;
using System.Linq;
using System.Text;

namespace PDU_Web_Editor.DAL
{
    public class PDUDbContext : DbContext
    {
        public PDUDbContext()
            : base("name=PDUDbContext")
        {
        }

        public DbSet<Asset> Assets { get; set; }
        public DbSet<Record> Records { get; set; }
        public DbSet<PDU> PDUs { get; set; }


        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {

            modelBuilder.Entity<Asset>().ToTable("tbl_Assets");
            modelBuilder.Entity<PDU>().ToTable("tbl_PDUs");
            modelBuilder.Entity<Record>().ToTable("tbl_Records");

            //modelBuilder.Entity<PDU>()
            //    .HasMany(c => c.Records).WithMany(i => i.PDUs)
            //    .Map(t => t.MapLeftKey("Pdr_PDUUniqueId")
            //    .MapRightKey("Pdr_RecordId")
            //    .ToTable("tbl_PduRecords"));
            //}

            modelBuilder.Entity<PDU>()
                .HasMany(p => p.Records)
                .WithRequired()
                .HasForeignKey(r => r.Rec_PDUUniqueId);
       
         }
    }
}

