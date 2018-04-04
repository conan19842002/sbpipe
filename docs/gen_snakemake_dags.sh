#!/usr/bin/env bash

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


SNAKE_FOLDER="../tests/snakemake"

cd $SNAKE_FOLDER

# PDF
snakemake -s ../../sbpipe_pe.snake --configfile ir_model_param_estim_for_dag.yaml --dag | dot -Tpdf > sbpipe_pe_snake_dag.pdf
snakemake -s ../../sbpipe_sim.snake --configfile ir_model_stoch_simul.yaml --dag | dot -Tpdf > sbpipe_sim_snake_dag.pdf
snakemake -s ../../sbpipe_ps1.snake --configfile ir_model_ir_beta_inhib_stoch.yaml --dag | dot -Tpdf > sbpipe_ps1_snake_dag.pdf
snakemake -s ../../sbpipe_ps2.snake --configfile ir_model_insulin_ir_beta_dbl_stoch_inhib.yaml --dag | dot -Tpdf > sbpipe_ps2_snake_dag.pdf

# PNG
snakemake -s ../../sbpipe_pe.snake --configfile ir_model_param_estim_for_dag.yaml --dag | dot -Tpng -Gdpi=300 > sbpipe_pe_snake_dag.png
snakemake -s ../../sbpipe_sim.snake --configfile ir_model_stoch_simul.yaml --dag | dot -Tpng -Gdpi=300 > sbpipe_sim_snake_dag.png
snakemake -s ../../sbpipe_ps1.snake --configfile ir_model_ir_beta_inhib_stoch.yaml --dag | dot -Tpng -Gdpi=300 > sbpipe_ps1_snake_dag.png
snakemake -s ../../sbpipe_ps2.snake --configfile ir_model_insulin_ir_beta_dbl_stoch_inhib.yaml --dag | dot -Tpng -Gdpi=300 > sbpipe_ps2_snake_dag.png

cd -

# moves pdf files
mv $SNAKE_FOLDER/*.pdf source/images/

# moves png files
mv $SNAKE_FOLDER/*.png source/images/
