# Store physical constants for later reference
class Constants:
    __author__ = 'jcdoll'

    def __init__(self, print_flag):
        self.kb = 1


class PlotHelper:
    __author__ = 'jcdoll'

    def __init__(self, print_flag):
        import matplotlib as mpl

        self.print_flag = print_flag

        # Setup nice colors (use ints and convert to 0-1)
        black = self.convert_color((0, 0, 0))
        darkGray = self.convert_color((50, 50, 50))
        gray = self.convert_color((128, 128, 128))
        lightGray = self.convert_color((200, 200, 200))
        white = self.convert_color((255, 255, 255))

        lightBlue = self.convert_color((60, 180, 250))
        blue = self.convert_color((11, 132, 199))
        darkBlue = self.convert_color((5, 60, 120))

        orange = self.convert_color((255, 102, 0))
        lightOrange = self.convert_color((255, 160, 30))
        darkOrange = self.convert_color((180, 50, 0))

        lightGreen = self.convert_color((0, 220, 0))
        green = self.convert_color((0, 153, 0))
        darkGreen = self.convert_color((0, 80, 0))

        lightRed = self.convert_color((255, 60, 60))
        red = self.convert_color((190, 20, 20))
        darkRed = self.convert_color((80, 10, 10))

        # Setup figure defaults
        mpl.rc('lines', linewidth=2, linestyle='-')
        mpl.rc('figure', facecolor='w')
        mpl.rc('axes', labelsize='medium', hold=True, linewidth=1.5)
        mpl.rc('figure.subplot', wspace=0.3, hspace=0.3)
        mpl.rc('axes', color_cycle=[blue, green, orange, red, lightBlue, lightGreen, lightOrange,
                                    lightRed, darkBlue, darkGreen, darkOrange, darkRed])
        mpl.rc('savefig', dpi=150)

    def convert_color(self, color_tuple):
        return tuple(x / 255.0 for x in color_tuple)

    def print_plot(self, filename):
        import matplotlib.pyplot as plt

        assert isinstance(self.print_flag, int)
        if self.print_flag:
            plt.savefig(filename)