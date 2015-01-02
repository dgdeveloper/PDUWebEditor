using PDU_Web_Editor.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PDUWebEditorUnitTestProject.Helper
{
    public static class TestDataFactory
    {
        //test data for PDU
        public static IEnumerable<PDU> PDUs
        {
            get
            {
                yield return new PDU()
                {
                    Pdu_PDUUniqueId = 1,
                    Pdu_FileName = "PDUDemo1",
                    Pdu_UpdateByWho = @"CONNEX\xiguo",
                    Pdu_UpdateOnDate = new DateTime(2014, 08, 25, 10, 2, 58),
                    Pdu_Type = "Hospitality",
                    Pdu_ScreenSize = "FullScreen",
                    Records =new List<Record>(),
                };
                yield return new PDU()
                {
                    Pdu_PDUUniqueId = 2,
                    Pdu_FileName = "PDUDemo2",
                    Pdu_UpdateByWho = @"CONNEX\xiguo",
                    Pdu_UpdateOnDate = new DateTime(2014, 08, 25, 10, 38, 51),
                    Pdu_Type = "Hospitality",
                    Pdu_ScreenSize = "VSplit",
                    Records = new List<Record>(),
                };
            }
        }

        //test data for records
        public static IEnumerable<Record> Records
        {

            get
            {
                yield return new Record()
                {
                    Rec_RecordId = 1,
                    Rec_RecordName = "649 SuperDraw-June1-27.2014",
                    Rec_RecordStartDate = new DateTime(2014, 06, 01),
                    Rec_RecordEndDate = new DateTime(2014, 06, 27),
                    Rec_RecordWeight = 5,
                    Rec_AssetFileName = "SuperDraw_Full.swf",
                    Rec_PDUUniqueId = 1,
                    Asset = null,
                    PDU = null
                };
                yield return new Record()
                {
                    Rec_RecordId = 2,
                    Rec_RecordName = "GameSense-Odds-June2-July7.2014",
                    Rec_RecordStartDate = new DateTime(2014, 06, 02),
                    Rec_RecordEndDate = new DateTime(2014, 07, 07),
                    Rec_RecordWeight = 5,
                    Rec_AssetFileName = "GS_Odds_Full.swf",
                    Rec_PDUUniqueId = 1,
                    Asset = null,
                    PDU = null
                };
                yield return new Record()
                {
                    Rec_RecordId = 3,
                    Rec_RecordName = "649 SuperDraw-June1-27.2014",
                    Rec_RecordStartDate = new DateTime(2014, 05, 06),
                    Rec_RecordEndDate = new DateTime(2014, 07, 29),
                    Rec_RecordWeight = 3,
                    Rec_AssetFileName = "SuperDraw_Full.swf",
                    Rec_PDUUniqueId = 2,
                    Asset = null,
                    PDU = null
                };
                yield return new Record()
                {
                    Rec_RecordId = 4,
                    Rec_RecordName = "Mobile PDU - Subscription",
                    Rec_RecordStartDate = new DateTime(2014, 08, 22),
                    Rec_RecordEndDate = new DateTime(2014, 08, 23),
                    Rec_RecordWeight = 4,
                    Rec_AssetFileName = "Mobile_PDU_Full.swf",
                    Rec_PDUUniqueId = 2,
                    Asset = null,
                    PDU = null
                };

            }
        }

        public static IEnumerable<Asset> Assets
        {

            get
            {
                yield return new Asset()
                {
                    Ast_FileName = "SuperDraw_Full.swf",
                    Ast_UpdatedByWho = @"CONNEX\xiguo",
                    Ast_UpdatedOnDate = @"8/22/2014 4:30:43 PM",
                    Ast_FileLocation = "Animations/Ads/SuperDraw_Full.swf",
                    Ast_ScreenSize = "FullScreen",
                    Records = new List<Record>()
                };
                yield return new Asset()
                {
                    Ast_FileName = "GS_Odds_Full.swf",
                    Ast_UpdatedByWho = @"CONNEX\xiguo",
                    Ast_UpdatedOnDate = @"8/25/2014 10:19:36 AM",
                    Ast_FileLocation = "Images/VSplitAds/GameSense-Odds-June2-July7.2014",
                    Ast_ScreenSize = "VSplit",
                    Records = new List<Record>()
                };
                yield return new Asset()
                {
                    Ast_FileName = "Mobile_PDU_Full.swf",
                    Ast_UpdatedByWho = @"CONNEX\xiguo",
                    Ast_UpdatedOnDate = @"8/22/2014 4:30:43 PM",
                    Ast_FileLocation = "Animations/Ads/Mobile_PDU_Full.swf",
                    Ast_ScreenSize = "FullScreen",
                    Records = new List<Record>()
                };
            }
        }
    }
}
