using Charamaker2;
using Charamaker2.Character;
using Charamaker2.input;
using GameSet1;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using THE_Tournament.relic;
using THE_Tournament.wepon;

namespace THE_Tournament
{
    class PEventArgs : SEEventArgs
    {
        bool entpent;
        public PEventArgs(Sentity p, player tag, PlayerStatus s, float cl = 1) : base(p, tag, s, cl)
        {
            entpent = p.GetType() == typeof(player) || p.GetType().IsSubclassOf(typeof(player));
        }

        public player pent { get { if (!entpent) return null; return (player)ent; } set { ent = value; } }
        public player ptag { get { return (player)tag; } set { tag = value; } }

    }

    class PEventer : SEEventer
    {
        public new player e { get { return (player)base.e; } }
        public PEventer(player p) : base(p)
        {

        }

        public event EventHandler<WEventArgs> soubi;
        public event EventHandler<WEventArgs> unsoubi;
        public void soubied(Wepon w)
        {
            soubi?.Invoke(w, new WEventArgs(w, w, null));
        }
        public void unsoubied(Wepon w)
        {
            unsoubi?.Invoke(w, new WEventArgs(w, w, null));
        }

        public event EventHandler<PEventArgs> damchange;
        public event EventHandler<PEventArgs> sizechange;

        public event EventHandler<PEventArgs> jizokuchange;
        public event EventHandler<PEventArgs> coolchange;
        public event EventHandler<PEventArgs> skillchange;
        public event EventHandler<PEventArgs> speedchange;

        public void damchanged(object sender, Sentity sent, PlayerStatus w)
        {
            damchange?.Invoke(sender, new PEventArgs(sent, e, w));
        }
        public void sizechanged(object sender, Sentity sent, PlayerStatus w)
        {
            sizechange?.Invoke(sender, new PEventArgs(sent, e, w));
        }
        public void jizokuchanged(object sender, Sentity sent, PlayerStatus w)
        {
            jizokuchange?.Invoke(sender, new PEventArgs(sent, e, w));
        }
        public void coolchanged(object sender, Sentity sent, PlayerStatus w)
        {
            coolchange?.Invoke(sender, new PEventArgs(sent, e, w));
        }
        public void skillchanged(object sender, Sentity sent, PlayerStatus w)
        {
            skillchange?.Invoke(sender, new PEventArgs(sent, e, w));
        }
        public void speedchanged(object sender, Sentity sent, PlayerStatus w)
        {
            speedchange?.Invoke(sender, new PEventArgs(sent, e, w));
        }

        public event EventHandler<PEventArgs> Dodamchange;
        public event EventHandler<PEventArgs> Dosizechange;

        public event EventHandler<PEventArgs> Dojizokuchange;
        public event EventHandler<PEventArgs> Docoolchange;
        public event EventHandler<PEventArgs> Doskillchange;
        public event EventHandler<PEventArgs> Dospeedchange;

        public void Dodamchanged(object sender, player tag, PlayerStatus w)
        {
            Dodamchange?.Invoke(sender, new PEventArgs(e, tag, w));
        }
        public void Dosizechanged(object sender, player tag, PlayerStatus w)
        {
            Dosizechange?.Invoke(sender, new PEventArgs(e, tag, w));
        }
        public void Dojizokuchanged(object sender, player tag, PlayerStatus w)
        {
            Dojizokuchange?.Invoke(sender, new PEventArgs(e, tag, w));
        }
        public void Docoolchanged(object sender, player tag, PlayerStatus w)
        {
            Docoolchange?.Invoke(sender, new PEventArgs(e, tag, w));
        }
        public void Doskillchanged(object sender, player tag, PlayerStatus w)
        {
            Doskillchange?.Invoke(sender, new PEventArgs(e, tag, w));
        }
        public void Dospeedchanged(object sender, player tag, PlayerStatus w)
        {
            Dospeedchange?.Invoke(sender, new PEventArgs(e, tag, w));
        }
        override public void influted<T, E>(E sent, T s, bool over = false)
        {
            if (typeof(T) == typeof(PlayerStatus) || typeof(T).IsSubclassOf(typeof(PlayerStatus)))
            {
                var sss = s as PlayerStatus;
                if (over)
                {

                }
                else
                {
                    if (sss.dam != 0)
                    {
                        damchanged(sss, sent, sss);
                    }
                    if (sss.speed != 0)
                    {
                        speedchanged(sss, sent, sss);
                    }
                    if (sss.size != 0)
                    {
                        sizechanged(sss, sent, sss);
                    }
                    if (sss.jizoku != 0)
                    {
                        jizokuchanged(sss, sent, sss);
                    }
                    if (sss.cool != 0)
                    {
                        coolchanged(sss, sent, sss);
                    }
                    if (sss.skill != 0)
                    {
                        skillchanged(sss, sent, sss);
                    }
                }
            }
        }
        /// <summary>
        /// こいつが攻撃するときとかこう
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="tag"></param>
        /// <param name="s"></param>
        /// <param name="over"></param>
        public override void Doinfluted<T, E>(E tag, T s, bool over = false)
        {
            base.Doinfluted(tag, s, over);

            if (typeof(T) == typeof(PlayerStatus) || typeof(T).IsSubclassOf(typeof(PlayerStatus)))
            {
                if (typeof(E) == typeof(player) || typeof(E).IsSubclassOf(typeof(player)))
                {

                    var sss = s as PlayerStatus;
                    var tttag = s as player;

                    tttag.s.influte(e, sss, over);


                    if (over)
                    {

                    }
                    else
                    {
                        if (sss.dam != 0)
                        {
                            Dodamchanged(sss, tttag, sss);
                        }
                        if (sss.speed != 0)
                        {
                            Dospeedchanged(sss, tttag, sss);
                        }
                        if (sss.size != 0)
                        {
                            Dosizechanged(sss, tttag, sss);
                        }
                        if (sss.jizoku != 0)
                        {
                            Dojizokuchanged(sss, tttag, sss);
                        }
                        if (sss.cool != 0)
                        {
                            Docoolchanged(sss, tttag, sss);
                        }
                        if (sss.skill != 0)
                        {
                            Doskillchanged(sss, tttag, sss);
                        }
                    }

                }
            }
        }
    }
    
    class player : Sentity
    {
        public bool autoskill = true;
        public new PEventer EEV { get { return (PEventer)_EEV; } }
        protected override void setEEventer()
        {
            _EEV = new PEventer(this);
        }
        public new PlayerStatus s { get { return (PlayerStatus)this._s; } }

       

        public player(PlayerStatus s, character c, ABrecipie a, buturiinfo b) : base(s, c, a, b) 
        {
            
        }
        //  public new PlayerStatus s { get { return s; } }

        protected float _syatei=300;
        public float syatei {get{ return _syatei; }set { _syatei = Math.Max(value, 0); } }
        public float Tsyatei { get { return _syatei * (sank.C * 0.7f + 1f); } }

        protected sankakuha sank=new sankakuha();
        
        public void UIn(inputin i,hyojiman hyo, float cl,bool battle=true) 
        {
            if (battle)
            {
         
                new effectchara(hyo, cl, c.gettx(), c.getty(), 0, 0, 0, 0, 0, new setu("core", Tsyatei, 0, new picture(0, 0, 9999999
                    , 2, 10, 1, 5, 0, false, 0.8f, "def", new Dictionary<string, string> { { "def", "redbit" } })));

                new effectchara(hyo, cl, c.gettx(), c.getty(), 0, 0, 0, 0, 0, new setu("core", -Tsyatei, 0, new picture(0, 0, 9999999
             , 2, 10, 1, 5, 0, false, 0.8f, "def", new Dictionary<string, string> { { "def", "redbit" } })));

                for (int ii=0;ii<WS.Count;ii++)
                {
                    WS[ii].UIn(ii,i, hyo, cl);
                }
            }
            for(int j=0;j<relics.Count;j++)
            {
                relics[j].UIn(j,i, hyo, cl);
            }
        }

       

        /// <summary>
        /// ちょくせつADDすな！
        /// </summary>
        public readonly List<weponslot> WS = new List<weponslot>();

        public readonly List<player> tag = new List<player>();
        
        /// <summary>
        /// 直接呼び出すな！
        /// </summary>
        /// <param name="w">w.soubiを呼び出せ！</param>
        /// <returns></returns>
        public weponslot soubi(Wepon w)
        {
            for (int i = 0; i < WS.Count; i++) 
            {
                if (WS[i].weponset(w))
                {
                    EEV.soubied(w);
                    return WS[i];
                }
            }
            return null;
        }

        /// <summary>
        /// 直接呼び出すな！
        /// </summary>
        /// <param name="w">w.soubiを呼び出せ！</param>
        /// <returns></returns>
        public weponslot unsoubi(Wepon w)
        {
            for (int i = 0; i < WS.Count; i++)
            {
                if (WS[i].weponunset(w))

                {
                    EEV.unsoubied(w);
                    return WS[i];
                }
            }
            return null;
        }
        public override void frame(float cl)
        {
            base.frame(cl);
            
            foreach (var a in WS) 
            {
                a.frame(cl);
            }
            if (autoskill&&tag.Count>0) 
            {
                int i = fileman.r.Next()%tag.Count;

                foreach (var a in WS) 
                {
                    a.autoskill(tag[i]);
                }
            }
            
            for (int i = tag.Count - 1; i >= 0; i--) 
            {
                if (!tag[i].onEM) 
                {
                    tag.RemoveAt(i);

                }
            }
            idou(cl);
           
        }

        protected virtual void idou(float cl)
        {
            sank.Time += (fileman.whrandhani(s.speed*12)/10 / syatei)  * cl;
            
            if (fileman.percentin(0.1f)) { sank.Time *= -1; }

            float kyo = Tsyatei;
            int hou = 0;

            var me = new List<float> {
                c.getcx(0,0),c.getcy(0, 0),c.getcx(c.w, 0),c.getcy(c.w, 0),
            c.getcx(0,c.h),c.getcy(0, c.h),c.getcx(c.w, c.h),c.getcy(c.w, c.h) };

            player motikatag = null;
            float motikakyo = 0;

            foreach (var a in tag)
            {
                var u = new List<float> {
                    a.c.getcx(0,0),a.c.getcy(0, 0),a.c.getcx(c.w, 0),a.c.getcy(c.w, 0),
            a.c.getcx(0,c.h),a.c.getcy(0, c.h),a.c.getcx(c.w, c.h),a.c.getcy(c.w, c.h) };

                float min = (u[0] - me[0]);
                int tenhou = 0;
                for (int i = 0; i < 8; i += 2)
                {
                    for (int t = 0; t < 8; t += 2)
                    {
                        var temp = (u[t] - me[i]);
                        if (Math.Abs(temp) < Math.Abs(min))
                        {
                            min = temp;
                        }
                        if (temp < 0)
                        {
                            tenhou--;
                        }
                        else if (temp > 0)
                        {
                            tenhou++;
                        }
                    }
                }
                if (motikatag == null || motikakyo < min)
                {
                    motikatag = a;
                    motikakyo = min;
                }
                float tenkyo = kyo;
                if (tenhou < 0) tenkyo *= -1;
                if (tenkyo - min < 0)
                {
                    hou++;
                }
                else
                {
                    hou--;
                }

            }
            if (hou > 0)
            {

                //  c.mirror = false;
                c.idouxy(s.speed * cl, 0);
            }
            else if (hou < 0)
            {
                // c.mirror = true;
                c.idouxy(-s.speed * cl, 0);
            }
            if (motikatag != null)
            {
                c.mirror = (motikatag.c.gettx() - c.gettx() < 0);
            }
        }
        public virtual void input(inputin i,float cl)
        {
            foreach (var a in WS)
            {
                a.input(i,cl);
            }
        }
        protected override void onAdd()
        {
            base.onAdd();
            foreach (var a in WS) 
            {
                a.onadd(EM);
            }
        
        }
        public override bool remove()
        {
            return base.remove();
        }
        protected override void onRemove()
        {
            base.onRemove();
            foreach (var a in WS)
            {
                a.wep?.remove();
            }

        }


        /// <summary>
        /// ちょくせつADDすな！
        /// </summary>
        public readonly List<Relic> relics = new List<Relic>();

        /// <summary>
        /// 直接呼び出すな
        /// </summary>
        /// <param name="r"></param>
        /// <returns></returns>
        public bool addRelic(Relic r)
        {
            if (!relics.Contains(r)) 
            {
                relics.Add(r);
                return true;
            }

            return false;
        }


        /// <summary>
        /// 直接呼び出すな
        /// </summary>
        /// <param name="r"></param>
        /// <returns></returns>
        public bool removeRelic(Relic r)
        {

            if (relics.Remove(r))
            {

                return true;
            }

            return false;
        }
        public int fase=0;
    }

    class PlayerStatus : status
    {
        public float speed { get { return _speed; } }
        public float mspeed { get { return _mspeed; } }

        public float dam { get { return _dam; } }
        public float mdam { get { return _mdam; } }

        public float cool { get { return _cool; } }
        public float mcool { get { return _mcool; } }

        public float skill { get { return _skill; } }
        public float mskill { get { return _mskill; } }

        public float jizoku { get { return _jizoku; } }
        public float mjizoku { get { return _mjizoku; } }

        public float size { get { return _size; } }
        public float msize { get { return _msize; } }

        protected float _speed,_mspeed,
            _dam,_mdam,
            _cool,_mcool,
            _skill,_mskill,
            _jizoku,_mjizoku,
            _size,_msize;

        static public PlayerStatus PSFromParam(string param,List<zokusei> z=null) 
        {
            return new PlayerStatus(FP.PR(param, 0), FP.PR(param, 1), FP.PR(param, 2), FP.PR(param, 3), FP.PR(param, 4), FP.PR(param, 5), FP.PR(param, 6), z);
        }

        public PlayerStatus(float health = 0,float speed = 0,float dam=0,float cool=0,float skill=0,float jizoku=0,float size=0,List<zokusei>z=null) : base(health,z) 
        {
            _speed = speed; _mspeed = speed;
            _dam = dam; _mdam = dam;
            _cool = cool; _mcool = cool;
            _skill = skill; _mskill = skill;
            _jizoku = jizoku; _mjizoku = jizoku;
            _size = size; _msize = size;
        }

        public PlayerStatus(PlayerStatus p) :base(p)
        {
            _speed = p._speed; _mspeed = p._mspeed;
            _dam = p._dam; _mdam = p._mdam;
            _cool = p._cool; _mcool = p._mcool;
            _skill = p._skill; _mskill = p._mskill;
            _jizoku = p._jizoku; _mjizoku = p._mjizoku;
            _size = p._size; _msize = p._msize;
        }

        public override void start()
        {
            base.start();
            _dam = _mdam;
            _speed = _mspeed;
            _cool = _mcool;
            _skill = _mskill;
            _jizoku = _mjizoku;
            _size = _msize;

        }

        /// <summary>
        /// 
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="mot">nullも可</param>
        /// <param name="s"></param>
        /// <param name="over"></param>
        override public void influte<T>(Sentity mot, T s, bool over = false)
            
        {
            base.influte(mot, s, over);
            if (typeof(T) == typeof(PlayerStatus) || typeof(T).IsSubclassOf(typeof(PlayerStatus)))
            {
                var sss = s as PlayerStatus;
                foreach (var a in Eventin)
                {

                    a.EEV.influted<PlayerStatus,Sentity>(mot, sss, over);

                }

                if (over)
                {
                    {
                        _mspeed += sss._speed;
                        if (_mspeed < _speed)
                        {

                            _speed += Math.Max(_mspeed - _speed, sss._speed);
                        }
                        if (_mspeed < 0)
                        {
                            sss._speed -= _mspeed;
                        }
                    }
                    {
                        _mdam += sss._dam;
                        if (_mdam < _dam)
                        {

                            _dam += Math.Max(_mdam - _dam, sss._dam);
                        }
                        if (_mdam < 0)
                        {
                           sss._dam -= _mdam;
                        }
                    }
                    {
                        _mjizoku += sss._jizoku;
                        if (_mjizoku < _jizoku)
                        {

                            _jizoku += Math.Max(_mjizoku - _jizoku, sss._jizoku);
                        }
                        if (_mjizoku < 0)
                        {
                            sss._jizoku -= _mjizoku;
                        }
                    }
                    {
                        _msize += sss._size;
                        if (_msize < _size)
                        {

                            _size += Math.Max(_msize - _size, sss._size);
                        }
                        if (_msize < 0)
                        {
                            sss._size -= _msize;
                        }
                    }
                    {
                        _mcool += sss._cool;
                        if (_mcool < _cool)
                        {

                            _cool += Math.Max(_mcool - _cool, sss._cool);
                        }
                        if (_mcool < 0)
                        {
                            sss._cool -= _mcool;
                        }
                    }
                    {
                        _mskill += sss._skill;
                        if (_mskill < _skill)
                        {

                            _skill += Math.Max(_mskill - _skill, sss._skill);
                        }
                        if (_mskill < 0)
                        {
                            sss._skill -= _mskill;
                        }
                    }

                }
                else
                {
                    {
                        _speed += sss._speed;
                        if (_speed < 0)
                        {
                            sss._speed -= _speed;
                        }
                    }
                    {
                        _dam += sss._dam;
                        if (_dam < 0)
                        {
                            sss._dam -= _dam;
                        }
                    }
                    {
                        _size += sss._size;
                        if (_size < 0)
                        {
                            sss._size -= _size;
                        }
                    }
                    {
                        _jizoku += sss._jizoku;
                        if (_jizoku < 0)
                        {
                            sss._jizoku -= _jizoku;
                        }
                    }
                    {
                        _cool += sss._cool;
                        if (_cool < 0)
                        {
                            sss._cool -= _cool;
                        }
                    }
                    {
                        _skill += sss._skill;
                        if (_skill < 0)
                        {
                            sss._skill -= _skill;
                        }
                    }
                }
            }



           
        }
        public override string printstatus(bool nowmo=true,bool nakutomo=false)
        {
            var res = "";
            if (nowmo)
            {
                res += FP.GT("SNhel") + ":" + Math.Round(_hel).ToString() + "/" + Math.Round(_mhel).ToString()
                      + " " + FP.GT("SNspeed") + ":" + Math.Round(_speed,1)*10 + "/" + Math.Round(_mspeed,1)*10
                      + " " + FP.GT("SNdam") + ":" + Math.Round(_dam,2) + "/" + Math.Round(_mdam,2)
                      + " " + FP.GT("SNjizoku") + ":" + Math.Round(_jizoku,2) + "/" + Math.Round(_mjizoku,2)
                      + " " + FP.GT("SNsize") + ":" + Math.Round(_size,2) + "/" + Math.Round(_msize,2)
                      + " " + FP.GT("SNcool") + ":" + Math.Round(_cool,2) + "/" + Math.Round(_mcool,2)
                      + " " + FP.GT("SNskill") + ":" + Math.Round(_skill,2) + "/" + Math.Round(_mskill,2) + " ";

               
            }
            else 
            {
                if(_mhel>0||nakutomo)res += FP.GT("SNhel") + ":" + Math.Round(_mhel).ToString()+" ";
                if (_mspeed > 0 || nakutomo) res += FP.GT("SNspeed") + ":" + Math.Round(_mspeed,1)*10 + " ";
                if (_mdam > 0 || nakutomo) res += FP.GT("SNdam") + ":" + Math.Round(_mdam,2) + " ";
                if (_mjizoku > 0 || nakutomo) res += FP.GT("SNjizoku") + ":" + Math.Round(_mjizoku,2) + " ";
                if (_msize > 0 || nakutomo) res += FP.GT("SNsize") + ":" + Math.Round(_msize,2) + " ";
                if (_mcool > 0 || nakutomo) res += FP.GT("SNcool") + ":" + Math.Round(_mcool,2) + " ";
                if (_mskill > 0 || nakutomo) res += FP.GT("SNskill") + ":" + Math.Round(_mskill,2) + " ";
              
            }
            if (z.Count > 0 || nakutomo)
            {
                res += " " + FP.GT("SNzokusei") + ":";
                foreach (var a in z)
                {
                    res += FP.GT("SN" + a.ToString());
                }
            }
            return res;
        }
        override public string save()
        {
            var res =  _mhel
                + ":" + _mspeed
                + ":" + _mdam
                + ":" + _mjizoku
                 + ":" + _msize
                 + ":" + _mcool
                 + ":" + _mskill;
            foreach (var a in z)
            {
                res += ":"+a.ToString() ;
            }
            return res;
        }
        override public void load(string a)
        {
            var aas = a.Split(':');

            this._mhel = Convert.ToSingle(aas[0]);
            this._mspeed = Convert.ToSingle(aas[1]);
            this._mdam = Convert.ToSingle(aas[2]);
            this._mjizoku = Convert.ToSingle(aas[3]);
            this._msize = Convert.ToSingle(aas[4]);
            this._mcool = Convert.ToSingle(aas[5]);
            this._mskill = Convert.ToSingle(aas[6]);
            this.z.Clear();
            for (int i = 7; i < aas.Length; i++)
            {
                this.z.Add((zokusei)Enum.Parse(typeof(zokusei), aas[5]));
            }
        }
    }



   
}
