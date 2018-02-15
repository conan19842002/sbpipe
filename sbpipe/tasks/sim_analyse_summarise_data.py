#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# This file is part of sbpipe.
#
# sbpipe is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# sbpipe is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with sbpipe.  If not, see <http://www.gnu.org/licenses/>.
#
#
#
# $Revision: 3.0 $
# $Author: Piero Dalle Pezze $
# $Date: 2016-11-01 15:43:32 $


import os
import sys
import argparse
import logging
logger = logging.getLogger('sbpipe')

# retrieve SBpipe package path
SBPIPE = os.path.abspath(os.path.join(__file__, os.pardir, os.pardir, os.pardir))
sys.path.insert(0, SBPIPE)

from sbpipe.utils.parcomp import run_cmd


def sim_analyse_summarise_data(inputdir,
                               model,
                               outputfile_repeats,
                               variable):
    """
    Plot model simulation time courses (Python wrapper).

    :param inputdir: the directory containing the data to analyse
    :param model: the model name
    :param outputfile_repeats: the output file containing the model simulation repeats
    :param variable: the model variable to analyse
    """

    # requires devtools::install_github("pdp10/sbpiper")
    command = 'R -e \'library(sbpiper); summarise_data(\"' + inputdir + \
              '\", \"' + model + \
              '\", \"' + outputfile_repeats
    # we replace \\ with / otherwise subprocess complains on windows systems.
    command = command.replace('\\', '\\\\')
    # We do this to make sure that characters like [ or ] don't cause troubles.
    command += '\", \"' + variable + \
               '\")\''
    logger.debug(command)
    run_cmd(command)


# this is a Python wrapper for sim analysis in R.
def main(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument('--inputdir')
    parser.add_argument('-m', '--model')
    parser.add_argument('--outputfile_repeats')
    parser.add_argument('--variable')

    args = parser.parse_args()
    sim_analyse_summarise_data(args.inputdir,
                               args.model,
                               args.outputfile_repeats,
                               args.variable)
    return 0


if __name__ == "__main__":
    sys.exit(main())