using Kendo.Mvc.UI;
using Kendo.Mvc.Extensions;
using PDU_Web_Editor.DAL;
using PDU_Web_Editor.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.IO;



namespace PDU_Web_Editor.ControllersTestSet
{
    public class AssetController : Controller
    {
        private IUnitOfWork _unitOfWork;

        public AssetController() : this(new SqlUnitOfWork(new PDUDbContext())) { }

        public AssetController(IUnitOfWork unitOfWork)
        {
            this._unitOfWork = unitOfWork;

        }

        public ActionResult Index()
        {
            ViewBag.Message = "Assets Page";
            //screenSize for dropdown list binding
            ViewBag.screenSizes = new List<SelectListItem>() {
                                                            new SelectListItem() {
                                                                 Text = "VSplit",
                                                                 Value = "VSplit"
                                                             },
                                                            new SelectListItem() {
                                                                Text = "FullScreen",
                                                                 Value = "FullScreen"
                                                            }
                                                         };
               return View("Index");
        }

        public ActionResult Assets_Read([DataSourceRequest]DataSourceRequest request)
        {
            IQueryable<Asset> assets = _unitOfWork.AssetRepository.Get().AsQueryable();
            DataSourceResult result = assets.ToDataSourceResult(request, a => new
            {//avoid circular reference
                Ast_FileName = a.Ast_FileName,
                Ast_UpdatedByWho = a.Ast_UpdatedByWho,
                Ast_UpdatedOnDate = a.Ast_UpdatedOnDate,
                Ast_FileLocation = a.Ast_FileLocation,
                Ast_ScreenSize = a.Ast_ScreenSize,
            });
            return Json(result);
        }
        
        public ActionResult SaveUploadFile(IEnumerable<HttpPostedFileBase> assetFile,String screenSize)
        {
            foreach (var file in assetFile)
            {
                // Some browsers send file names with full path. We only care about the file name.
                var fileName = Path.GetFileName(file.FileName);

                PDUCustomConfigurationSection _pdyCustomConfig = (PDUCustomConfigurationSection)System.Configuration.ConfigurationManager.GetSection("PDUCustomConfigurationGroup/PDUCustomConfiguration");

                //no duplicate file is allowed
                //String vSplitDestinationPath = Path.Combine(Server.MapPath("~/PDURunTime/pduv4500/webshow/pdu/Images/VSplitAds"), fileName);
                //String fullScreenDestinationPath =Path.Combine(Server.MapPath("~/PDURunTime/pduv4500/webshow/pdu/Animations/Ads"), fileName);
                String vSplitDestinationPath = Path.Combine(Server.MapPath(_pdyCustomConfig.PDUFolder.Path+"/Images/VSplitAds"), fileName);
                String fullScreenDestinationPath = Path.Combine(Server.MapPath(_pdyCustomConfig.PDUFolder.Path+"/Animations/Ads"), fileName);
                if (System.IO.File.Exists(vSplitDestinationPath) || System.IO.File.Exists(fullScreenDestinationPath))
                {
                    return Content("the file with the same name exists already");
                    //return Json(new { status = "OK" }, "text/plain");
                }

                string destinationPath = string.Empty;
                string destinationRelativePath = string.Empty;
                if (screenSize == "VSplit")
                {
                    destinationPath = Path.Combine(Server.MapPath(_pdyCustomConfig.PDUFolder.Path+"/Images/VSplitAds"), fileName);
                    destinationRelativePath = "Images/VSplitAds/" + fileName;
                }
                else
                {
                    destinationPath = Path.Combine(Server.MapPath(_pdyCustomConfig.PDUFolder.Path+"/Animations/Ads"), fileName);
                    destinationRelativePath = "Animations/Ads/" + fileName;
                }
               
                file.SaveAs(destinationPath);
                //update asset db table
                using (var assetRepository = _unitOfWork.AssetRepository)
                {
                    //Create a new Asset Entity
                    Asset newAsset = new Asset
                    {
                        Ast_FileName = fileName,
                        Ast_UpdatedByWho = HttpContext.User.Identity.Name,
                        Ast_UpdatedOnDate = DateTime.Now.ToString("G"),
                        Ast_FileLocation = destinationRelativePath,
                        Ast_ScreenSize = screenSize,
                       
                    };
                    //Add the entity
                    assetRepository.Insert(newAsset);
                    //Save the entity to the database
                    assetRepository.Save();

                }

            }

            // Return an empty string to signify success
            return Content("");
        }

        public ActionResult Assets_Delete([DataSourceRequest]DataSourceRequest request, Asset asset)
        {
            PDUCustomConfigurationSection _pdyCustomConfig = (PDUCustomConfigurationSection)System.Configuration.ConfigurationManager.GetSection("PDUCustomConfigurationGroup/PDUCustomConfiguration");
            var destinationPath = Path.Combine(Server.MapPath(_pdyCustomConfig.PDUFolder.Path+"/"), asset.Ast_FileLocation);
            

            if (!System.IO.File.Exists(destinationPath))
            {

                return this.Json(new DataSourceResult
                {
                    Errors = "the asset file has been removed already"
                });
            }
            //delete the physical file
            System.IO.File.Delete(destinationPath);
            //update db table
            using (var assetRepository = _unitOfWork.AssetRepository)
            {
                assetRepository.Delete(asset.Ast_FileName);
                assetRepository.Save();
            }

            return Json(new[] { asset }.ToDataSourceResult(request, ModelState));
        }

        protected override void Dispose(bool disposing)
        {
            _unitOfWork.Dispose();
            base.Dispose(disposing);
        }
    }
}
