using GameSet1;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using THE_Tournament.relic;
using THE_Tournament.scene;

namespace THE_Tournament
{
    class upgradecard
    {
        public readonly string n;
       
        public int kai=0;
        int g;
        public string name { get {return FP.GT("UN" + n); } }
        public string setumei { get { return FP.GT("UPgold",null, kai, gold)+"\n"+ FP.GT("UP"+n); } }
        public int gold{ get { return (1+kai) * g; } }
        public int sellgold { get { return ( kai) * g; } }
        public string tex { get { return @"upgrade\"+n; } }
        public upgradecard(string name,int gold) 
        {
            this.g = gold;
            this.n = name;
        }
        public bool buy(SD s) 
        {
          //  Console.WriteLine(gold+" this.gold "+kai);

            if (s.buy(gold)) 
            {
                s.upgradescript+=n+":";
                return true;
            }
            return false;
        }

        public bool goodbye(SD s)
        {
            //  Console.WriteLine(gold+" this.gold "+kai);
            if (kai > 0)
            {
                s.gaingold(sellgold);
                var gh = new List<string>(s.upgradescript.Split(':'));
                gh.Remove(n);
                s.upgradescript = "";
                foreach (var a in gh)
                {
                    s.upgradescript += a + ":";
                }
                return true;

            }
            return false;
        }

        public EventHandler<UPEventAG> go;
        public void Go(UPEventAG a) {
            this.yomikomi(a.u);
            a.kai = this.kai;
            go.Invoke(this, a); }

        public int yomikomi(upgrade u) { kai = u.yomikomi(n); return kai; }
    }
    class UPEventAG 
    {
        public int kai=0;
        public List<treasure> t=new List<treasure>();
        public List<Relic> r=new List<Relic>();
        public UPEventAG(upgrade up) { u = up; }
        public upgrade u;
    }
  
    class upgrade
    {
        static protected upgradecard makestdcard(List<upgradecard>lis,string name,int gold=0)
        {
            if (gold <= 0) gold = (int)FP.PR("statusupgradegold");
            var res = new upgradecard(name, gold);
            lis.Add(res);
            return res;
        }
        static protected List<upgradecard> getstdcards() 
        {
            var res = new List<upgradecard>();

            makestdcard(res,"health").go+=(a,b)=> 
            {
                b.r.Add(new soubihin("startrelic"
                    , new PlayerStatus(health:FP.PR("healthorbP") * b.kai)));
            };
            makestdcard(res, "speed").go += (a, b) =>
            {
                b.r.Add(new soubihin("startrelic"
                    , new PlayerStatus(speed: FP.PR("speedorbP") * b.kai)));
            };
            makestdcard(res, "dam").go += (a, b) =>
            {
                b.r.Add(new soubihin("startrelic"
                    , new PlayerStatus(dam: FP.PR("damorbP") * b.kai)));
            };
            makestdcard(res, "size").go += (a, b) =>
            {
                b.r.Add(new soubihin("startrelic"
                    , new PlayerStatus(size: FP.PR("sizeorbP") * b.kai)));
            };
            makestdcard(res, "jizoku").go += (a, b) =>
            {
                b.r.Add(new soubihin("startrelic"
                    , new PlayerStatus(jizoku: FP.PR("jizokuorbP") * b.kai)));
            };
            makestdcard(res, "cool").go += (a, b) =>
            {
                b.r.Add(new soubihin("startrelic"
                    , new PlayerStatus(cool: FP.PR("coolorbP") * b.kai)));
            };
            makestdcard(res, "skill").go += (a, b) =>
            {
                b.r.Add(new soubihin("startrelic"
                    , new PlayerStatus(skill: FP.PR("skillorbP") * b.kai)));
            };
            makestdcard(res, "startsign", (int)FP.PR("treasureupgradegold")).go += (a, b) =>
            {
                if(b.kai>0) b.t.Add(new treasure(rank.bubble, itemtype.relic, Math.Min(b.kai, 7), SD.S.sin.stdbai()));
            }; 

            return res;
        }
        protected List<upgradecard> upgradecards;
        public List<upgradecard> Upgradecards { get { return new List<upgradecard>(upgradecards); } }

      
        protected List<string> loaded = new List<string>();
        
        public upgrade(string upgradescript) 
        {
           
            loaded = new List<string>(upgradescript.Split(':'));
            upgradecards = getstdcards();
            getTreasures();
        }

        public List<treasure> getTreasures() 
        {
            var res=new List<treasure> {new treasure(rank.bogo,itemtype.util,1,SD.S.sin.stdbai()),
                   // new treasure(rank.tim,itemtype.wepon,5,SD.S.sin.stdbai()),new treasure(rank.bubble,itemtype.relic,5,SD.S.sin.stdbai()),new treasure(rank.bubble,itemtype.relic,5,SD.S.sin.stdbai()),new treasure(rank.bubble,itemtype.relic,5,SD.S.sin.stdbai()),
               //     new treasure(rank.n,itemtype.wepon,8,SD.S.sin.stdbai()),  new treasure(rank.n,itemtype.wepon,8,SD.S.sin.stdbai()),  new treasure(rank.n,itemtype.wepon,8,SD.S.sin.stdbai()),  new treasure(rank.n,itemtype.wepon,8,SD.S.sin.stdbai())
                new treasure(rank.bogo,itemtype.wepon,1,SD.S.sin.stdbai()),new treasure(rank.bogo,itemtype.wepon,2,SD.S.sin.stdbai()),new treasure(rank.bogo,itemtype.wepon,3,SD.S.sin.stdbai()),
                };

            foreach (var a in upgradecards)
            {
                var e = new UPEventAG(this);
                a.Go(e);
                res.AddRange(e.t);
            }
          /*
            if (yomikomi("startsign")>0)
            {
                res.Add(new treasure(rank.bubble, itemtype.relic, Math.Min(yomikomi("startsign"),5) , SD.S.sin.stdbai()));
            }*/
            return res;
        }
        public List<Relic> getRelics() 
        {
            var res = new List<Relic>();
            
            foreach (var a in upgradecards) 
            {
                var e = new UPEventAG(this);
                a.Go(e);
                res.AddRange(e.r);
            }/*
            var s=new soubihin("startrelic",new PlayerStatus(
                FP.PR("healthorbP")* yomikomi("health")
               , FP.PR("speedorbP") * yomikomi("speed")
                , FP.PR("damorbP") * yomikomi("dam")
                , FP.PR("coolorbP") * yomikomi("cool")
                , FP.PR("skillorbP") * yomikomi("skkill")
                , FP.PR("jizokuorbP") * yomikomi("jizoku")
                , FP.PR("sizeorbP") * yomikomi("size")));

            res.Add(s);*/
            return res;
        }

        public int yomikomi(string s)
        {
            int sum = 0;
            foreach (var a in loaded)
            {
              //  Console.WriteLine(s + "::" + a);
                if (a == s)
                {
                    sum += 1;
                }
            }
            return sum;

        }
        public static string cleanscript(string upgradescrypt) 
        {
            var a = new upgrade(upgradescrypt);
            var lis = new List<string>(upgradescrypt.Split(':'));

            var res = "";
            foreach (var b in a.upgradecards)
            {
                for (int i = lis.Count - 1; i >= 0; i--)
                {

                    if (b.n == lis[i])
                    {
                        res += lis[i] + ":";
                        lis.RemoveAt(i);
                    }
                }
            }

            return res;
        }
    }
}
