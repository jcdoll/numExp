# Store physical constants for later reference
class Constants:
    __author__ = 'jcdoll'

    def __init__(self, print_flag):
        self.kb = 1


class PlotHelper:
    __author__ = 'jcdoll'

    def __init__(self, print_flag):
        import matplotlib as mpl

        # Store settings for later
        self.print_flag = print_flag

        # Setup figure defaults
        mpl.rc('lines', linewidth=2, linestyle='-')
        mpl.rc('figure', facecolor='w')
        mpl.rc('axes', labelsize='medium', hold=True, linewidth=1.5)
        mpl.rc('figure.subplot', wspace=0.3, hspace=0.3)
        mpl.rc('axes', color_cycle = ['r', 'k', 'c'])
        mpl.rc('savefig', dpi=150)

    def print_plot(self, filename):
        import matplotlib.pyplot as plt

        assert isinstance(self.print_flag, int)
        if self.print_flag:
            plt.savefig(filename)