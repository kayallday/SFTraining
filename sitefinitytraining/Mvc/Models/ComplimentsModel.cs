using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SitefinityWebApp.Mvc.Models
{
    public class ComplimentsModel
    {
        private string _compliments;
        //private bool _allowInsults;

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

        //public bool AllowInsults { set { _allowInsults = value; } }
        private string[] _complimentsArray => _compliments.Split(',').Select(c => c.Trim()).ToArray();

        public ComplimentsModel()
        {
            _compliments = "You ARE as cool as you think";
            //_allowInsults = false;
        }
        public ComplimentsModel(string compliments, bool optionalInsults = false)
        {
            this._compliments = compliments;
            //_allowInsults = optionalInsults;
        }
        public string ComplimentMe()
        {
            Random rnd = new Random();
            //if (_allowInsults)
            //{
            //    if (rnd.Next(3) == 0)
            //        return "You smell like fish sticks";
            //}
            //if (String.IsNullOrEmpty(_compliments))
            //    return "Default Compliment";
            int r = rnd.Next(_complimentsArray.Count());
            return _complimentsArray[r];
        }
    }
}