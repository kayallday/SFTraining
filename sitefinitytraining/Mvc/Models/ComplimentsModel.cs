using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SitefinityWebApp.Mvc.Models
{
    public class ComplimentsModel
    {
        private string _compliments;

        public string Compliments
        {
            get
            {
                return _compliments;
            }
            set
            {
                _compliments = value;
            }
        }
        private string[] _complimentsArray => _compliments.Split(',').Select(c => c.Trim()).ToArray();
        public ComplimentsModel()
        {
            _compliments = "You're the best... AROUNDDD! Nothing's gonna ever bring you down!.";
        }
        public ComplimentsModel (string compliments)
        {
            this._compliments = compliments;
        }
        public string ComplimentMe()
        {
            if (String.IsNullOrEmpty(_compliments))
                return "Default Compliment";
            Random rnd = new Random();
            int r = rnd.Next(_complimentsArray.Count());
            return _complimentsArray[r];
        }
    }
}