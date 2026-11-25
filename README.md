# Visuomotor policies for square nut assembly

Compare a diffusion policy with a behavior-cloning regressor on the same two camera views and robot state. The diffusion model predicts a short action sequence; the controller executes the first actions and replans.

## Run from a clone

Use Ubuntu 22.04 or WSL2, Python 3.10, Git, CMake, a C++ compiler, uv and EGL or Mesa OSMesa. Run from the repository root. The clone includes one complete 127-step human demonstration for a short training run.

```sh
uv venv --python 3.10 .venv
uv pip install --python .venv/bin/python -r requirements.txt
source .venv/bin/activate
python diffusion_policy.py --dataset_path examples/square-demo.hdf5 --gradient_steps 1 --batch_size 2 --eval_episodes 1 --max_episode_steps 2 --diffusion_steps 3 --device cpu --results_dir runs/demo
```

## Full dataset and experiments

```sh
bash fetch-data.sh
python diffusion_policy.py
python bc.py
```

The script downloads both parts of the 2.60 GB Square proficient-human image dataset from this repository's `experiments-v1` release, reconstructs the HDF5 file and verifies its SHA-256 before installation. The release also contains `training-results.tar` with the original training metrics, plots, videos and checkpoints. Extract that archive from the repository root to restore `results/`. Training can overwrite checkpoints; use a new `--results_dir` for new experiments.

Use `--predict_x0` for clean-action prediction, or `--mode inference --model_path PATH` with the corresponding architecture and dataset. Full training defaults to 100,000 gradient steps.

## Credits

Developed for CSC2626. The Square task and demonstrations come from [robomimic](https://robomimic.github.io/docs/datasets/robomimic_v0.1.html) (Mandlekar et al., CoRL 2021). The dataloader, diffusion process and backbones adapt [CleanDiffuser](https://github.com/CleanDiffuserTeam/CleanDiffuser); see the module docstrings and `licenses/`. The project compares diffusion targets and behavior cloning, with a shared observation pipeline and rollout evaluation.
