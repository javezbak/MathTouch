import braille_to_numbers
import os
import io
class Latex2binary(object):
    """docstring for Latex2binary"""
    def __init__(self):
        super(Latex2binary, self).__init__()
        self.brl2num = braille_to_numbers.braille_to_numbers 

    def l2b(self, latex_string):
        braille = self.latex2braille(latex_string)
        print(braille)
        binary = self.braille2binary(braille)
        print(binary)

        return binary

    def latex2braille(self, latex_string): 
        self.create_tmp_latex_file(latex_string) 
        os.system("java -jar latex2nemeth-code/target/latex2nemeth-v1.0.jar tmp/tmp.tex tmp/tmp.aux -o tmp/tmp")
        count = 0
        braille = ""
        with io.open('tmp/tmp0.nemeth', 'r', encoding='utf-16') as fh:
            for line in fh:
                if count == 1:
                    braille = line.rstrip()
                count += 1
        # braille = braille.decoding("utf-8")
        return braille
    def braille2binary(self, braille_string):
        binary_array = []
        for bc in braille_string:
            if bc == " ":
                continue
            binary_array.extend(self.brl2num[bc])
        ba = [str(i) for i in binary_array]
        return "".join(ba)

    def create_tmp_latex_file(self, latex_string):
        with open('tmp/tmp.tex', 'w') as fh:
            # ls = latex_string.encode("string_escape")
            template = r"""
\documentclass[a4paper,12pt]{article}% hvoss
\usepackage{pstricks-add,fullpage}
\usepackage{pst-3dplot,pst-solides3d}
\usepackage{pst-plot,pst-intersect,mathtools}

%\pagestyle{empty}
\begin{document}
""" + "$${}$$".format(latex_string) + r"""
\end{document}
"""
            
            fh.write(template)

        with open("tmp/tmp.aux", 'w') as fh:
            fh.write(r"\relax")
if __name__ == "__main__":
    l2b = Latex2binary() 
    l2b.l2b("2+1+2")
