using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Charamaker2;
using Charamaker2.input;
using Charamaker2.Character;
using GameSet1;
using Charamaker2.Shapes;
using THE_Tournament.scene;
using THE_Tournament.wepon;
using C2WebRTCP2P;
//通信用　using C2WebRTCP2P;死体場合はC2webRTCCP2Pを参照に追加してね！
// なんかわからんけど、mrwebrtc.dllがないって言われたらpackages->MixedRealityWebrtc->runtimes->win10-x86->nativにある
// やつをexeのとこまで持ってけ！

namespace THE_Tournament
{

    public partial class display : Form
    {
        /// <summary>
        /// テクスチャーとか音とか使いたいなら.exeの横にtex,otoってフォルダ作ってbmpとwavぶちこみな！
        ///モーションはmotion、キャラクターはcharacterにCharamaker2で作ってな
        ///hyojiman.playoto("jett");
        ///fileman.loadcharacter("yoshino");
        ///fileman.ldmotion("yoshino\\kougeki");
        ///とかいう具合や！
        ///セッティングを使用するためにはセッティング用のとこを解放しろ！
        /// </summary>
        inputin i = new inputin();
        SceneManager sm = new SceneManager();
        System.Drawing.Size size = new System.Drawing.Size(1200, 800);
        public display()
        {
          
            InitializeComponent();
            this.ClientSize = new System.Drawing.Size(size.Width, size.Height);

            SD.loadsave<SD>();
            if (SD.S == null)
            {
                fileman.setinguping(this, 1);

                SD.setup<SD>();
                SD.S.mvol = 0.1f;

            }
            else 
            {
                fileman.setinguping(this, SD.S.gsit);
            }
            SD.S.setvols();
            FP.seting(new List<string> {"texts\\Prelic1", "texts\\Pwepon1" },new List<string> { "texts\\upgrade1","texts\\help1"
                ,"texts\\relic1" ,"texts\\wepon1","texts\\system1","texts\\settingtext"});
            C2WebRTCP2P.supertusin.setup();
            new title(sm).start();
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void clocked(object sender, EventArgs e)
        {
            i.setpointer(sm.s.hyo, this);

            sm.s.frame(i, 1);

            i.topre();


            //セッティング用inputin.raw.topre();
        }

        private void keydown(object sender, KeyEventArgs e)
        {

            i.down(e.KeyCode, SD.S.converts);
            inputin.raw.down(e.KeyCode, inputin.rawconv);
        }

        private void keyup(object sender, KeyEventArgs e)
        {
            i.up(e.KeyCode, SD.S.converts);
            inputin.raw.up(e.KeyCode, inputin.rawconv);
        }

        private void mousedown(object sender, MouseEventArgs e)
        {
            i.down(e.Button, SD.S.converts);
            inputin.raw.down(e.Button, inputin.rawconv);
        }

        private void mouseup(object sender, MouseEventArgs e)
        {
            i.up(e.Button, SD.S.converts);
           inputin.raw.up(e.Button, inputin.rawconv);
        }

        private void closing(object sender, FormClosingEventArgs e)
        {
            supertusin.shutdown();
        }

        private void resized(object sender, EventArgs e)
        {
            int sum = this.ClientSize.Width + this.ClientSize.Height;
            this.ClientSize = new System.Drawing.Size(sum * size.Width / (size.Width + size.Height), sum * size.Height / (size.Width + size.Height));
        }

        private void shown(object sender, EventArgs e)
        {
            string now = this.Text;
            this.Text = "loading...";
            //出来上がりの時は開放してね
            fileman.loading += (a, b) =>
            {
                var i=new inputin();
                i.x = sm.s.hyo.ww * b.loadedhi;
                i.y = sm.s.hyo.wh * b.loadedhi;
                sm.s.frame(i, 1);
            };
            fileman.loadfiletoka();
            this.Text = now;
            fileman.playoto("kettei");
        }
    }
    abstract class Scene : GameSet1.Scene 
    {
        public new Scene next { get { return (Scene)base.next; }set { base.next=value; } }
        public Scene(SceneManager s,Scene next=null) : base(s,next)
        {
            MKHLP();
        }
        protected override void onstart()
        {
            base.onstart();
            if (SD.S.help) kirihelp();
            gatihai = picture.onetexpic(gatihaikei, 1);
           

        }
        List<message> mm = new List<message>();
        private void kirihelp() 
        {
            foreach (var m in mm) 
            {
                if (!m.add(hyo)) { m.remove(hyo);}
                else {  }
            }
        }
        private void MKHLP() 
        {
            mm = new List<message>();
            makehelps(mm);
            mtx = hyo.camx;
            mty = hyo.camy;
            mww = hyo.ww;
            mwh = hyo.wh;
        }
        protected abstract void makehelps(List<message> help);

        protected string getHelpstring(params string[] setus) 
        {
            string res=FP.GT("HL"+"help",SD.S.converts)+"\n";
            foreach (var a in setus)
            {
                res += FP.GT("HL" + a, SD.S.converts) + "\n";
            }
            return res;
        }

        private float mtx, mty,mww,mwh;
        
        private void helpidou ()
        {
            float hi = hyo.ww / mww;
            

            foreach (var a in mm)
            {
                float xxx = (a.x-mtx) / mww;
                float yyy = (a.y-mty) / mwh;

                a.x = hyo.camx + hyo.ww * xxx;
                a.y = hyo.camy + hyo.wh * yyy;

                a.SIZE *= hi;
            }
            mtx = hyo.camx;
            mty = hyo.camy;
            mww = hyo.ww;
            mwh = hyo.wh;
        }
       
        public override void frame(inputin i, float cl)
        {
            
            helpidou();
            hyo.begindraw(true);
            drawgatihai(cl);
            hyo.hyoji(cl,false,false);
            drawkiri(cl);
            drawcursor(i,cl);
            
            hyo.enddraw();

         
            if (i.ok(Keys.H, itype.down)) 
            {
                SD.S.help = !SD.S.help;
                kirihelp();
            }

           
        }
        float kirilong = 20; 
        float kiriframe = 20;
        picture fade = new picture(0, 0, 0, 0, 0, 0, 0, 0, false, 1, "def", new Dictionary<string, string> { { "def", "whitebit" } });
        virtual protected void drawkiri(float cl) 
        {
            if (kiriframe >= 0)
            {
                fade.x = hyo.camx;
                fade.y = hyo.camy;
                fade.w = hyo.ww;
                fade.h = hyo.wh;
                fade.OPA = 0.20f*(float)Math.Pow(kiriframe / kirilong,1);
                kiriframe -= cl;
                fade.draw(hyo, cl, true);
            }

        }
        picture cursor = new picture(0, 0, 0, 64, 64, 32, 32, 0, false, 0.7f, "def", new Dictionary<string, string> { { "def", "window\\cursour" }, { "red", "window\\redcursour" } });
        protected void drawcursor(inputin i,float cl)
        {
            if (i.x <= hyo.camx || hyo.camx + hyo.ww <= i.x || i.y <= hyo.camy || hyo.camy + hyo.wh <= i.y)
            {
                cursor.texname = "red";
                Cursor.Show();
            }
            else
            {
                cursor.texname = "def";
                //Cursor.Hide();
            }
            cursor.w =  64/ hyo.bairitu;
            cursor.h = 64 / hyo.bairitu;
            cursor.tx = 64 / hyo.bairitu/2;
            cursor.ty = 64 / hyo.bairitu/2;
            cursor.settxy(i.x,i.y);
            cursor.draw(hyo, cl, true);

        }
        protected string gatihaikei = "window\\gatihai";
        picture gatihai=null;
        protected void drawgatihai(float cl)
        {
            gatihai.x = hyo.camx;
            gatihai.y = hyo.camy;
            gatihai.w = hyo.ww;
            gatihai.h = hyo.wh;
            gatihai.draw(hyo, cl, true);

        }
        static protected void makeeff(hyojiman hyo)
        {
            List<string> texs = new List<string> { "effects\\firebit","effects\\icebit","effects\\windbit","effects\\earthbit", "effects\\thunderbit"
                ,"effects\\lightbit", "effects\\darkbit","effects\\physicbit" };
            float time = fileman.whrandhani(100) + 50;
            float si = fileman.whrandhani(50) + 25;
            float z = -100 - fileman.whrandhani(100);
            float opa = fileman.whrandhani(100) / 100 + 0.3f;
            double rad = fileman.r.NextDouble() * Math.PI * 2;
            float tx = hyo.camx + hyo.ww * fileman.whrandhani(2000) / 1000 - 0.5f;
            float ty = hyo.camy + hyo.wh * fileman.whrandhani(2000) / 1000 - 0.5f;

            float sp = fileman.whrandhani(100) / 10;


            var eff = new effectchara(hyo, time, character.onepicturechara(texs[fileman.r.Next() % texs.Count], si, z, false, 0.5f, 0.5f, opa, rad, tx, ty));
            eff.addmotion(new idouman(time * 10, sp * (float)Math.Sin(rad), sp * (float)Math.Cos(rad), fileman.plusminus() * sp * fileman.whrandhani(1000) / 100));
            if (fileman.percentin(25))
            {
                eff.addmotion(new Kopaman(time, "", 0));
                eff.addmotion(new Kscalechangeman(time, "", 0, 0));
            }
            else if (fileman.percentin(50))
            {
                eff.addmotion(new Kscalechangeman(time, "", 0, 0));
            }
            else
            {
                eff.addmotion(new Kopaman(time, "", 0));
            }
        }
    }


}
