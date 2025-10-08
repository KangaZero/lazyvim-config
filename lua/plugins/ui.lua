return {
  "snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        pick = function(cmd, opts)
          return LazyVim.pick(cmd, opts)
        end,
        header = [[
                             ./+o+-       
                  yyyyy- -yyyyyy+      
               ://+//////-yyyyyyo     
           .++ .:/++++++/-.+sss/`    
         .:++o:  /++++++++/:--:/-   
        o:+o+:++.`..```.-/oo+++++/ 
       .:+o:+o/.          `+sssoo+/    
  .++/+:+oo+o:`             /sssooo.  
 /+++//+:`oo+o               /::--:. 
 \+/+o+++`o++o               ++////.
  .++.o+++oo+:`             /dddhhh.
       .+.o+oo:.          `oddhhhh+    
        \+.++o+o``-````.:ohdhhhhh+
         `:o+++ `ohhhhhhhhyo++os:
           .o:`.syhhhhhhh/.oo++o`
               /osyyyyyyo++ooo+++/
                   ````` +oo+++o\:
                          `oo++.
              [@KangaZero]
        ]],
      },
    },
  },
}
