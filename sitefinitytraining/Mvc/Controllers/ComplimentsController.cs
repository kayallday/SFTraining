using SitefinityWebApp.Mvc.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Telerik.Sitefinity.Mvc;

namespace SitefinityWebApp.Mvc.Controllers
{
    [ControllerToolboxItem(Name = "Complimentor", Title = "Complimentor", SectionName = "Whatever")]
    public class ComplimentsController : Controller 
    {
        public string Compliments { get; set; }

        public ActionResult Index()
        {
            //ViewBag.MyCompliments = Compliments;
            var model = new ComplimentsModel(Compliments);
            return View(model);
        }
    }
}