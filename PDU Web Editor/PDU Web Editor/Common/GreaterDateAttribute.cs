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
    public sealed class GreaterDateAttribute : ValidationAttribute, IClientValidatable
    {
        public string EarlierDateField { get; set; }

        public GreaterDateAttribute()
            : base("Select a greater date")
        {

        }
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            DateTime? date = value != null ? (DateTime?)value : null;
            var earlierDateValue = validationContext.ObjectType.GetProperty(EarlierDateField)
                .GetValue(validationContext.ObjectInstance, null);
            DateTime? earlierDate = earlierDateValue != null ? (DateTime?)earlierDateValue : null;

            if (date.HasValue && earlierDate.HasValue && date <= earlierDate)
            {
                return new ValidationResult(ErrorMessage);
            }
            return ValidationResult.Success;
        }
        //registe validation rule 
        public IEnumerable<ModelClientValidationRule> GetClientValidationRules(ModelMetadata metadata, ControllerContext context)
        {
            var rule = new ModelClientValidationRule
            {
                ErrorMessage = ErrorMessage,
                ValidationType = "greaterdate"
            };

            yield return rule;
        }
    }
}