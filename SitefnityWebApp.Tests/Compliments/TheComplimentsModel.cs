using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SitefinityWebApp.Mvc.Controllers;
using SitefinityWebApp.Mvc.Models;

namespace SitefnityWebApp.Tests
{
    [TestClass]
    public class TheComplimentsModel
    {
        [TestMethod]
        public void Exists()
        {

            var complimentsModel = new ComplimentsModel();
        }

        [TestMethod]
        public void HasCompliments()
        {
            var complimentsModel = new ComplimentsModel();
            Assert.AreEqual("You ARE as cool as you think", complimentsModel.Compliments);
        }

        [TestMethod]
        public void CanCompliment()
        {

            var complimentsModel = new ComplimentsModel();
            Assert.AreEqual("You ARE as cool as you think", complimentsModel.Compliments);
        }

        [TestClass]
        public class GivenSomeCompliments
        {
            [TestMethod]
            public void ItWillComplimentYouWithVariety()
            {
                //create this test, create a new compliments model and make use of that overload
                //setting up a REST API Service
            }
        }
    }
}
