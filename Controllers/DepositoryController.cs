using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Proj_Depository.Models;
using Oracle.ManagedDataAccess.Client;

using System.Configuration;
using System.Data;
using System.Text;
using System.IO;
using OfficeOpenXml;
using System.Drawing;
using OfficeOpenXml.Style;

namespace Proj_Depository.Controllers
{
    public class DepositoryController : Controller
    {
        //GET: Depository
        [HttpGet]
        public ActionResult Add_Depository()
        {
            DepositoryModel obj = new DepositoryModel();
            ViewBag.depoList = bind_dropdown_depo();
           
            return View(obj);
        }

        public List<DepoistoryCode> bind_dropdown_depo()
        {
            DepoistoryCode obj = new DepoistoryCode();
            List<DepoistoryCode> listObj = new List<Models.DepoistoryCode>();

            string constr = ConfigurationManager.AppSettings["con"].ToString();
            OracleConnection con = new OracleConnection(constr);
            con.Open();
            OracleCommand cmd = new OracleCommand("PKG_MAST_DP.bind_dropdown_depo_proc", con);
            cmd.CommandType = CommandType.StoredProcedure;
            OracleParameter p1 = cmd.Parameters.Add("dt_records", OracleDbType.RefCursor);
            p1.Direction = ParameterDirection.Output;

            DataTable dt = new DataTable();
            OracleDataAdapter da = new OracleDataAdapter(cmd);
            da.Fill(dt);



            foreach (DataRow dr in dt.Rows)
            {

                listObj.Add(new DepoistoryCode
                {
                    depo_code = dr["md_depo_code"].ToString(),
                    depo_id = Convert.ToInt32(dr["md_depo_id"])
                });
            }

            return listObj;

        }


        [HttpGet]
        public ActionResult Update_Depository()
        {
            DepositoryModel obj = new DepositoryModel();
            ViewBag.depoList = bind_dropdown_depo();

            try
            {
                obj.dp_id = Request.QueryString["dp_id"].ToString();

                if (obj.dp_id != null)
                {
                    string constr = ConfigurationManager.AppSettings["con"].ToString();
                    OracleConnection con = new OracleConnection(constr);
                    con.Open();
                    OracleCommand cmd = new OracleCommand("PKG_MAST_DP.read_proc", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("p_dp_id", OracleDbType.Varchar2).Value = obj.dp_id;
                    cmd.Parameters.Add("search_dp_name", OracleDbType.Varchar2).Value = null;
                    OracleParameter p1 = cmd.Parameters.Add("dt_records", OracleDbType.RefCursor);
                    p1.Direction = ParameterDirection.Output;

                    DataTable dt = new DataTable();
                    OracleDataAdapter da = new OracleDataAdapter(cmd);
                    da.Fill(dt);

                    obj.dp_id = dt.Rows[0]["dp_dp_id"].ToString();
                    obj.dp_id_org = dt.Rows[0]["dp_dp_id"].ToString();
                    obj.depo_id = Convert.ToInt32(dt.Rows[0]["dp_depo_id"]);
                    obj.depo_desc = dt.Rows[0]["depo_desc"].ToString();
                    obj.dp_name = dt.Rows[0]["dp_dp_name"].ToString();
                    obj.dp_addr1 = dt.Rows[0]["dp_dp_addr1"].ToString();
                    obj.dp_addr2 = dt.Rows[0]["dp_dp_addr2"].ToString();
                    obj.dp_addr3 = dt.Rows[0]["dp_dp_addr3"].ToString();
                    obj.dp_addr4 = dt.Rows[0]["dp_dp_addr4"].ToString();
                    obj.dp_city = dt.Rows[0]["dp_dp_city"].ToString();
                    obj.dp_state = dt.Rows[0]["dp_dp_state"].ToString();
                    obj.dp_pincode = dt.Rows[0]["dp_dp_pincode"].ToString();
                    obj.dp_tele_no = dt.Rows[0]["dp_dp_tele_no"].ToString();
                    obj.dp_fax_no = dt.Rows[0]["dp_dp_fax_no"].ToString();
                    obj.active_flag = Convert.ToInt32(dt.Rows[0]["dp_active_flag"]);

                    return View(obj);
                }
                return View();
            }

            catch (Exception e)
            {
                //ViewBag.ErrorMessage = "Error occurred while retrieving depository details : " + e.Message;
                ViewBag.retCode = 0;
                ViewBag.retMsg = "Update_Depository_Get : " + e.Message;
                TempData["RetCode"] = 0;
                TempData["RetMsg"] = "Update_Depository_Get : " + e.Message + "\nYou are redirected to the Depository Participant List.";
                return RedirectToAction("List_Depository");
            }

        }

        [HttpGet]
        public ActionResult List_Depository(string search_name)
        {
            //string strSearchText = "";
            //if (Request.QueryString["search_name"].ToString() == null)
            //    strSearchText= Request.QueryString["search_name"].ToString();

            List<DepositoryModel> listObj = new List<Models.DepositoryModel>();
            DepositoryModel new_model = new DepositoryModel();

            try
            {
                string constr = ConfigurationManager.AppSettings["con"].ToString();
                OracleConnection con = new OracleConnection(constr);
                con.Open();
                OracleCommand cmd = new OracleCommand("PKG_MAST_DP.read_proc", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_dp_id", OracleDbType.Int32).Value = null;
                cmd.Parameters.Add("search_dp_name", OracleDbType.Varchar2).Value = search_name;
                OracleParameter p1 = cmd.Parameters.Add("dt_records", OracleDbType.RefCursor);
                p1.Direction = ParameterDirection.Output;
                cmd.ExecuteNonQuery();

                DataTable dt = new DataTable();
                OracleDataAdapter da = new OracleDataAdapter(cmd);
                da.Fill(dt);

                foreach (DataRow dr in dt.Rows)
                {
                    DepositoryModel model = new DepositoryModel();

                    model.dp_id = dr["dp_dp_id"].ToString();
                    model.dp_id_org = dr["dp_dp_id"].ToString();
                    model.depo_id = Convert.ToInt32(dr["dp_depo_id"]);
                    model.depo_desc = dr["depo_desc"].ToString();
                    model.dp_name = dr["dp_dp_name"].ToString();
                    model.dp_addr1 = dr["dp_dp_addr1"].ToString();
                    model.dp_city = dr["dp_dp_city"].ToString();
                    model.dp_state = dr["dp_dp_state"].ToString();
                    model.dp_pincode = dr["dp_dp_pincode"].ToString();
                    model.dp_tele_no = dr["dp_dp_tele_no"].ToString();
                    model.active_flag = Convert.ToInt32(dr["dp_active_flag"]);
                    model.active_status = dr["active_status"].ToString();

                    listObj.Add(model);
                }
                if ( listObj.Count == 0)
                {
                    new_model.Count = 0;
                }
                else
                {
                    new_model.Count = 1;
                    new_model.DepositoryList = listObj;
                }
                
                return View(new_model);
            }

            catch (Exception e)
            {
                //ViewBag.ErrorMessage = "Error occurred while retrieving the depository list : " + e.Message;
                TempData["RetCode"] = 0;
                TempData["RetMsg"] = "List_Depository : " + e.Message;
                return View(new_model);
            }
        }

        [HttpGet]
        public ActionResult List_Download()
        {
            List<Excel> listObj = new List<Models.Excel>();

            string constr = ConfigurationManager.AppSettings["con"].ToString();
            OracleConnection con = new OracleConnection(constr);
            con.Open();
            OracleCommand cmd = new OracleCommand("PKG_MAST_DP.read_proc", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("p_dp_id", OracleDbType.Int32).Value = null;
            cmd.Parameters.Add("search_dp_name", OracleDbType.Varchar2).Value = null;
            OracleParameter p1 = cmd.Parameters.Add("dt_records", OracleDbType.RefCursor);
            p1.Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();

            DataTable dt = new DataTable();
            OracleDataAdapter da = new OracleDataAdapter(cmd);
            da.Fill(dt);

            foreach (DataRow dr in dt.Rows)
            {
                Excel model = new Excel();

                model.depo_desc = dr["depo_desc"].ToString();
                model.dp_id = dr["dp_dp_id"].ToString();
                model.dp_name = dr["dp_dp_name"].ToString();
                model.dp_addr1 = dr["dp_dp_addr1"].ToString();
                model.dp_addr2 = dr["dp_dp_addr2"].ToString();
                model.dp_addr3 = dr["dp_dp_addr3"].ToString();
                model.dp_addr4 = dr["dp_dp_addr4"].ToString();
                model.dp_city = dr["dp_dp_city"].ToString();
                model.dp_state = dr["dp_dp_state"].ToString();
                model.dp_pincode = dr["dp_dp_pincode"].ToString();
                model.dp_tele_no = dr["dp_dp_tele_no"].ToString();
                model.dp_fax_no = dr["dp_dp_fax_no"].ToString();
                model.active_status = dr["active_status"].ToString();

                listObj.Add(model);
            }

            string[] headers = {"Depository Name", "Depository Participant Id", "Depository Participant Name", "Address 1", "Address 2", "Address 3", "Address 4", "City", "State", "Pin Code", "Telephone No.", "Fax No.", "Active Status" };
            string headerBackgroundColor = "yellow";

            ExcelPackage.LicenseContext = LicenseContext.NonCommercial;

            using (ExcelPackage package = new ExcelPackage())
            {
                ExcelWorksheet worksheet = package.Workbook.Worksheets.Add("DepositoryList");

                for (int i = 0; i < headers.Length; i++)
                {
                    worksheet.Cells[1, i + 1].Value = headers[i];
                    using (ExcelRange headerRange = worksheet.Cells[1, i + 1])
                    {
                        headerRange.Style.Font.Size = 12;
                        headerRange.Style.Font.Bold = true;
                        headerRange.Style.Font.Color.SetColor(Color.Black);
                        headerRange.Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;
                        headerRange.Style.Fill.BackgroundColor.SetColor(ColorTranslator.FromHtml(headerBackgroundColor));
                    }
                }

                worksheet.Cells["A2"].LoadFromCollection(listObj, true);
                worksheet.DeleteRow(2);
                worksheet.Cells[worksheet.Dimension.Address].AutoFitColumns();
                //worksheet.Cells.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                //worksheet.Cells["B:B"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                //worksheet.Cells["H:M"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[worksheet.Dimension.Address].Style.Border.Top.Style = ExcelBorderStyle.Thin;
                worksheet.Cells[worksheet.Dimension.Address].Style.Border.Left.Style = ExcelBorderStyle.Thin;
                worksheet.Cells[worksheet.Dimension.Address].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                worksheet.Cells[worksheet.Dimension.Address].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;


                byte[] fileContents = package.GetAsByteArray();
                string fileName = "Depository_List.xlsx";

                TempData["RetCode"] = 2;
                TempData["RetMsg"] = "Downloaded Successfully";
                TempData["FileDownloaded"] = true;

                //return RedirectToAction("List_Depository");
                return File(fileContents, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", fileName);
            }
        }

        [HttpGet]
        public ActionResult Delete_Depository(string dp_id)
        {
            dp_id = Request.QueryString["dp_id"].ToString();
            //DepositoryModel obj = new DepositoryModel();
            //obj.dp_id = Convert.ToInt32(Request.QueryString["dp_id"]);

            try
            {
                string constr = ConfigurationManager.AppSettings["con"].ToString();
                OracleConnection con = new OracleConnection(constr);
                con.Open();

                OracleCommand cmd = new OracleCommand("PKG_MAST_DP.delete_proc", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_dp_id", OracleDbType.Varchar2).Value = dp_id;
                OracleParameter p1 = cmd.Parameters.Add("p_retCode", OracleDbType.Int32);
                p1.Direction = ParameterDirection.Output;
                p1.Size = 4;
                OracleParameter p2 = cmd.Parameters.Add("p_retMsg", OracleDbType.Varchar2);
                p2.Direction = ParameterDirection.Output;
                p2.Size = 100;
                cmd.ExecuteNonQuery();

                int intRetCode = Convert.ToInt32(cmd.Parameters["p_retCode"].Value.ToString());
                string strRetMsg = cmd.Parameters["p_retMsg"].Value.ToString();


                if (intRetCode > 0)
                {
                    //ViewBag.Code = intRetCode;
                    //ViewBag.Msg = strRetMsg;
                    TempData["RetCode"] = intRetCode;
                    TempData["RetMsg"] = strRetMsg;

                }

                return RedirectToAction("List_Depository");
            }

            catch (Exception e)
            {
                //ViewBag.ErrorMessage = "Error occurred while deleting the depository : " + e.Message;
                TempData["RetCode"] = 0;
                TempData["RetMsg"] = "Delete_Depository : " + e.Message;
                return RedirectToAction("List_Depository");
            }
        }


        [HttpPost]
        public ActionResult Add_Depository(DepositoryModel obj)
        {

            //Session["dp_id"] = Convert.ToInt32(Request.QueryString["dp_id"]);
            //obj.dp_id = Convert.ToInt32(Session["dp_id"].ToString());

            try
            {
                string constr = ConfigurationManager.AppSettings["con"].ToString();

                //obj.is_Saved = 0;
                //string constr = "User Id=PROJ_DB;Password=PROJ_DB;Data Source=XE;";

                //ConfigurationManager.ConnectionStrings["cs"].ConnectionString;
                //OracleConnection con = new OracleConnection(@"Data Source=XE;User Id=PROJ_DB;Password=PROJ_DB;");

                OracleConnection con = new OracleConnection(constr);
                con.Open();

                if (obj.dp_id_org == null)
                {
                    OracleCommand cmd = new OracleCommand("PKG_MAST_DP.insert_proc", con);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("p_dp_id", OracleDbType.Varchar2).Value = obj.dp_id;
                    cmd.Parameters.Add("p_depo_id", OracleDbType.Int32).Value = obj.depo_id;
                    cmd.Parameters.Add("p_dp_name", OracleDbType.Varchar2).Value = obj.dp_name;
                    cmd.Parameters.Add("p_dp_addr1", OracleDbType.Varchar2).Value = obj.dp_addr1;
                    cmd.Parameters.Add("p_dp_addr2", OracleDbType.Varchar2).Value = obj.dp_addr2;
                    cmd.Parameters.Add("p_dp_addr3", OracleDbType.Varchar2).Value = obj.dp_addr3;
                    cmd.Parameters.Add("p_dp_addr4", OracleDbType.Varchar2).Value = obj.dp_addr4;
                    cmd.Parameters.Add("p_dp_city", OracleDbType.Varchar2).Value = obj.dp_city;
                    cmd.Parameters.Add("p_dp_state", OracleDbType.Varchar2).Value = obj.dp_state;
                    cmd.Parameters.Add("p_dp_pincode", OracleDbType.Varchar2).Value = obj.dp_pincode;
                    cmd.Parameters.Add("p_do_tele_no", OracleDbType.Varchar2).Value = obj.dp_tele_no;
                    cmd.Parameters.Add("p_dp_fax_no", OracleDbType.Varchar2).Value = obj.dp_fax_no;
                    cmd.Parameters.Add("p_active_flag", OracleDbType.Int32).Value = obj.active_flag;
                    OracleParameter p1 = cmd.Parameters.Add("p_retCode", OracleDbType.Int32);
                    p1.Direction = ParameterDirection.Output;
                    p1.Size = 4;
                    OracleParameter p2 = cmd.Parameters.Add("p_retMsg", OracleDbType.Varchar2);
                    p2.Direction = ParameterDirection.Output;
                    p2.Size = 100;
                    cmd.ExecuteNonQuery();

                    int intRetCode = Convert.ToInt32(cmd.Parameters["p_retCode"].Value.ToString());
                    string strRetMsg = cmd.Parameters["p_retMsg"].Value.ToString();

                    ViewBag.RetCode = intRetCode;
                    ViewBag.RetMsg = strRetMsg;
                    ViewBag.dpId = obj.dp_id.ToUpper();

                    if (intRetCode == 1)
                    {
                       
                        obj.dp_id_org = obj.dp_id;
                        //this.Response.Redirect("~/Depository/Update_Depository?dp_id=" + obj.dp_id);
                    }
                }

                //OracleCommand cmd = new OracleCommand("PKG_MAST_DP.insert_or_update_proc", con);
                //cmd.CommandType = CommandType.StoredProcedure;

                //int r = cmd.ExecuteNonQuery();

                //obj.is_Saved = r;
                ViewBag.depoList = bind_dropdown_depo();
                return View(obj);
            }
            
            catch(Exception e)
            {
                //ViewBag.ErrorMessage = "Error occurred while saving the depository : " + e.Message;
                ViewBag.retCode = 0;
                ViewBag.retMsg = "Add_Depository_Post : " + e.Message;
                return View();
            }

        }


        [HttpPost]
        public ActionResult Update_Depository(DepositoryModel obj)
        {

            //Session["dp_id"] = Convert.ToInt32(Request.QueryString["dp_id"]);
            //obj.dp_id = Convert.ToInt32(Session["dp_id"].ToString());

            try
            {
                string constr = ConfigurationManager.AppSettings["con"].ToString();

                OracleConnection con = new OracleConnection(constr);
                con.Open();

                OracleCommand cmd = new OracleCommand("PKG_MAST_DP.update_proc", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("p_dp_id", OracleDbType.Varchar2).Value = obj.dp_id;
                cmd.Parameters.Add("p_org_dp_id", OracleDbType.Varchar2).Value = obj.dp_id;
                cmd.Parameters.Add("p_depo_id", OracleDbType.Int32).Value = obj.depo_id;
                cmd.Parameters.Add("p_dp_name", OracleDbType.Varchar2).Value = obj.dp_name;
                cmd.Parameters.Add("p_dp_addr1", OracleDbType.Varchar2).Value = obj.dp_addr1;
                cmd.Parameters.Add("p_dp_addr2", OracleDbType.Varchar2).Value = obj.dp_addr2;
                cmd.Parameters.Add("p_dp_addr3", OracleDbType.Varchar2).Value = obj.dp_addr3;
                cmd.Parameters.Add("p_dp_addr4", OracleDbType.Varchar2).Value = obj.dp_addr4;
                cmd.Parameters.Add("p_dp_city", OracleDbType.Varchar2).Value = obj.dp_city;
                cmd.Parameters.Add("p_dp_state", OracleDbType.Varchar2).Value = obj.dp_state;
                cmd.Parameters.Add("p_dp_pincode", OracleDbType.Varchar2).Value = obj.dp_pincode;
                cmd.Parameters.Add("p_do_tele_no", OracleDbType.Varchar2).Value = obj.dp_tele_no;
                cmd.Parameters.Add("p_dp_fax_no", OracleDbType.Varchar2).Value = obj.dp_fax_no;
                cmd.Parameters.Add("p_active_flag", OracleDbType.Int32).Value = obj.active_flag;
                OracleParameter p1 = cmd.Parameters.Add("p_retCode", OracleDbType.Int32);
                p1.Direction = ParameterDirection.Output;
                p1.Size = 4;
                OracleParameter p2 = cmd.Parameters.Add("p_retMsg", OracleDbType.Varchar2);
                p2.Direction = ParameterDirection.Output;
                p2.Size = 100;
                cmd.ExecuteNonQuery();

                int intRetCode = Convert.ToInt32(cmd.Parameters["p_retCode"].Value.ToString());
                string strRetMsg = cmd.Parameters["p_retMsg"].Value.ToString();

                ViewBag.RetCode = intRetCode;
                ViewBag.RetMsg = strRetMsg;
                ViewBag.dpId = obj.dp_id.ToUpper();

                if (intRetCode == 1)
                {
                    obj.dp_id_org = obj.dp_id;
                }

                ViewBag.depoList = bind_dropdown_depo();
                return View();
            }

            catch (Exception e)
            {
                //ViewBag.ErrorMessage = "Error occurred while saving the depository : " + e.Message;
                ViewBag.retCode = 0;
                ViewBag.retMsg = "Update_Depository_Post : " + e.Message;
                return View();
            }

        }

    }
}