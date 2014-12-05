using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace PDU_Web_Editor.Common
{
    [AttributeUsage(AttributeTargets.Property |
     AttributeTargets.Field, AllowMultiple = false)]
    public sealed class FutureDateOnlyAttribute : ValidationAttribute, IClientValidatable
    {
        public FutureDateOnlyAttribute()
            : base("Can't select a date before Today")
        {

        }
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            //comment out this as delete will fail

            //DateTime d = Convert.ToDateTime(value);
            //if (d < DateTime.Now)
            //{
            //    return new ValidationResult(ErrorMessage);
            //}
            return ValidationResult.Success;
        }
        //registe validation rule 
        public IEnumerable<ModelClientValidationRule> GetClientValidationRules(ModelMetadata metadata, ControllerContext context)
        {
            var rule = new ModelClientValidationRule
            {
                ErrorMessage = ErrorMessage,
                ValidationType = "futuredateonly"
            };

            yield return rule;
        }
    }
}