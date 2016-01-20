#!/usr/bin/python
# -*- coding: utf-8 -*-
#
# License (GPLv3):
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or (at
# your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

import subprocess
from distutils.dir_util import copy_tree


process = subprocess.Popen(['sb_simulate.sh', 'model_ins_rec_v1_det_simul.conf'])
process.wait() 


process = subprocess.Popen(['sb_simulate.sh', 'model_ins_rec_v1_stoch_simul.conf'])
process.wait() 


process = subprocess.Popen(['sb_param_scan__single_perturb.sh', 'model_ins_rec_v1_single_perturbations_inhibitions.conf'])
process.wait() 


print "The script sb_sensitivity.sh does not run Copasi, but generates a plot for each file containing a square matrix in PROJECT/simulation/MODEL/SENSITIVITIES_FOLDER (here: ins_rec_model/simulation/insulin_receptor/sensitivities/)"
print "Let's copy some files containing sensitivity matrices into the folder SENSITIVITIES_FOLDER (here: sensitivities)"
copy_tree("../Data/sb_sensitivity_for_testing", "../simulations/insulin_receptor/sensitivities")

process = subprocess.Popen(['sb_sensitivity.sh', 'model_ins_rec_v1_sensitivities.conf'])
process.wait() 