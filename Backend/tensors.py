import tensorflow as tf
import os
from tensorflow.python.tools.inspect_checkpoint import print_tensors_in_checkpoint_file
curr= os.path.abspath(__file__)
temp=os.path.join(curr,"available_models")
checkpoint_dir=os.path.join(temp,"training_checkpoints/ckpt")
print_tensors_in_checkpoint_file(checkpoint_dir, all_tensors=True, tensor_name='')