using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GeniusThreaded
{
    class GeniusMethods
    {
        Dictionary<string,string> TransportKey = new Dictionary<string, string>();
        Dictionary<string,Dictionary<string,string>> Action = new Dictionary<string, Dictionary<string, string>>();
        public GeniusMethods()
        {
            //Build TransportKey Method
            TransportKey.Add("TransportKey","TransportKey");

            //Build All other functions
            AddActionMethod("Status");
            AddActionMethod("Cancel");

            AddActionMethod("GetSignature", "RequestID");
            AddActionMethod("GetSignature", "Title");



        }

        private void AddActionMethod(string action, string key = "")
        {
            //Fill blank Methods with an empty Dictionary and exit
            if(key == "")
            {
                Action.Add(action, new Dictionary<string, string>());
                return;
            }

            //Build temp method Dictionary
            Dictionary<string, string> tmpMethod = new Dictionary<string, string>();

            //Check if we are updating an existing Action
            if (Action.ContainsKey(action))
            {
                //Capture existing Methods of Action and Add Action
                tmpMethod = Action[action];
                tmpMethod.Add(key, key);
                Action[action] = tmpMethod;
            }
            else
            {
                //Build Method and Create Action
                tmpMethod.Add(key, key);
                Action.Add(action, tmpMethod);
            }
        }
    }
}
