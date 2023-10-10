using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Web;

namespace Proj_Depository.Models
{
    public class DepositoryModel
    {
        public string dp_id { get; set; }
        public string dp_id_org { get; set; }
        public int depo_id { get; set; }
        public string depo_desc { get; set; }
        public string dp_name { get; set; }
        public string search_name { get; set; }
        public string dp_addr1 { get; set; }
        public string dp_addr2 { get; set; }
        public string dp_addr3 { get; set; }
        public string dp_addr4 { get; set; }
        public string dp_city { get; set; }
        public string dp_state { get; set; }
        public string dp_pincode { get; set; }
        public string dp_tele_no { get; set; }
        public string dp_fax_no { get; set; }
        public int active_flag { get; set; } = -1;
        public string active_status { get; set; }
        public int crea_by { get; set; }
        public string crea_date { get; set; }
        public int modi_by { get; set; }
        public string modi_date { get; set; }
        public int Count { get; set; }
        public List<DepositoryModel> DepositoryList { get; set; }

    }

    public class Excel
    {
        public string depo_desc { get; set; }
        public string dp_id { get; set; }
        public string dp_name { get; set; }
        public string dp_addr1 { get; set; }
        public string dp_addr2 { get; set; }
        public string dp_addr3 { get; set; }
        public string dp_addr4 { get; set; }
        public string dp_city { get; set; }
        public string dp_state { get; set; }
        public string dp_pincode { get; set; }
        public string dp_tele_no { get; set; }
        public string dp_fax_no { get; set; }
        public string active_status { get; set; }
    }

    public class DepoistoryCode
    {
        public string depo_code { get; set; }
        public int depo_id { get; set; }
    }

}