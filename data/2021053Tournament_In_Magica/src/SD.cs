using Charamaker2;
using Charamaker2.input;
using Charamaker2.Shapes;
using GameSet1;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using THE_Tournament.relic;
using THE_Tournament.wepon;

namespace THE_Tournament
{
    [Serializable]
    class SD:GameSet1.SD
    {
        static public new SD S { get { return (SD)SD._S; } }

       public  Sintyokun sin=new Sintyokun();

        public bool help = true;

        protected int _gold = 0;
        public float bosslevel = 1;
        public int bossdare = 0;
        public int gold { get { return _gold; } }
        public bool canbuy(int p) { return _gold >= p; }
        public void gaingold (int p){ _gold += p; }
        public bool buy(int p) { if (canbuy(p)) { _gold -= p; return true; }return false; }

        public string upgradescript="";

        public upgrade getupgrade() 
        {
          
            this.upgradescript = upgrade.cleanscript(upgradescript);

            return new upgrade(this.upgradescript);
        }

        List<string> playerScripts=new List<string>();

        public List<string> getPlayerScripts() 
        {
            return playerScripts;
        }

        public void startplayer() { sin.resetfase(); playerScripts.Add("Wepon"); }
        static public string getPlayerScript(player p) 
        {
            string playerScript = p.fase.ToString() + "\n";
            foreach (var a in p.relics)
            {
                playerScript += a.save();

                playerScript += "\n";
            }
            playerScript += "Wepon\n";
            foreach (var a in p.WS)
            {
                if (a.wep != null)
                {
                    playerScript += a.wep.save();

                    playerScript += "\n";
                }
            }
            return playerScript;
        }
        public void setPlayerScript(player p) 
        {
           
            playerScripts[playerScripts.Count - 1] = getPlayerScript(p);
        }
        static public void loadPlayerScript(player p,string playerScript)
        {
         //   Console.WriteLine(playerScript);
            var aan = playerScript.Split('\n');
            int i = 0;
            p.fase = Convert.ToInt32(aan[i]);
            for (i = 1; i < aan.Length; i++)
            {
                if (aan[i] != "Wepon")
                {
                    Relic wep = Relic.load(aan[i]);
                    wep.add(p);
                }
                else
                {
                    i++;
                    break;
                }
            }
            for (; i < aan.Length; i++)
            {
                Wepon wep = Wepon.load(aan[i]);
                wep?.soubi(p);
            }
        }
        public void goPlayerScript(player p,int j)
        {
            var playerScript = playerScripts[j];
            loadPlayerScript(p, playerScript);
        }
        public List<player> goallPlayerScript(string atag="me")
        {
            var res = new List<player>();
            for (int i=0;i<playerScripts.Count;i++)
            {
                var p = Sintyokun.getstdplayer("me");
                goPlayerScript(p,i);
                res.Add(p);
            }
            return res;
        }
        public void removeplayerScript(int idx) 
        {
            playerScripts.RemoveAt(idx);
        }
        override public void resetIPC()
        {
            converts = new List<IPC> { new IPC(Keys.H,Keys.H), new IPC(Keys.W,Keys.W), new IPC(Keys.S, Keys.S), new IPC(Keys.A, Keys.A), new IPC(Keys.D, Keys.D)
                ,new IPC(Keys.E,Keys.E),new IPC(Keys.Q,Keys.Q),new IPC(Keys.R,Keys.R),new IPC(Keys.T,Keys.T),new IPC(Keys.G,Keys.G), new IPC(Keys.Space, Keys.Space)
                ,new IPC(Keys.Escape,Keys.Escape),new IPC(MouseButtons.Left,MouseButtons.Left),new IPC(MouseButtons.Right,MouseButtons.Right)
                 };
        }

    }

    

}
