class Constants:
    __author__ = 'jcdoll'

    def __init__(self, printflag):
        import matplotlib as mpl

        # Store settings for later
        self.printflag = printflag

        # Setup figure defaults
        mpl.rc('lines', linewidth=2, linestyle='-')
        mpl.rc('figure', facecolor='w')
        mpl.rc('axes', labelsize='medium', hold=True, linewidth=1.5)
        mpl.rc('figure.subplot', wspace=0.3, hspace=0.3)
        mpl.rc('axes', color_cycle = ['r', 'k', 'c'])
        mpl.rc('savefig', dpi=150)

    def printPlot(self, filename):
        import matplotlib.pyplot as plt

        if self.printflag:
            plt.savefig(filename)