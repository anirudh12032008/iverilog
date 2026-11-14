/*
 * $check_sv(name, is_vector, size): returns 0 if the checks pass, else 1.
 * Check that vpiVector, vpiScalar and
 * vpiSize of the object with the given full name match the expectation.
 * is_vector is 1 for an object declared with a packed range (even if the
 * range has a single element) and 0 for a plain scalar.
 */

#include <stdio.h>
#include <vpi_user.h>

static void set_result(vpiHandle call, int failed)
{
      s_vpi_value value;
      value.format = vpiIntVal;
      value.value.integer = failed;
      vpi_put_value(call, &value, 0, vpiNoDelay);
}

static PLI_INT32 check_sv(PLI_BYTE8*data)
{
      (void)data;
      vpiHandle call = vpi_handle(vpiSysTfCall, 0);
      vpiHandle args = vpi_iterate(vpiArgument, call);
      s_vpi_value value;

      value.format = vpiStringVal;
      vpi_get_value(vpi_scan(args), &value);
      const char*name = value.value.str;

      value.format = vpiIntVal;
      vpi_get_value(vpi_scan(args), &value);
      int is_vector = value.value.integer;

      vpi_get_value(vpi_scan(args), &value);
      int size = value.value.integer;
      vpi_free_object(args);

      vpiHandle obj = vpi_handle_by_name((PLI_BYTE8*)name, 0);
      if (!obj) {
	    vpi_printf("FAILED: %s not found\n", name);
	    set_result(call, 1);
	    return 0;
      }

      int failed = vpi_get(vpiVector, obj) != is_vector ||
	  vpi_get(vpiScalar, obj) != !is_vector ||
	  vpi_get(vpiSize, obj) != size;
      if (failed)
	    vpi_printf("FAILED: %s: vpiVector=%d (exp %d) vpiScalar=%d (exp %d)"
		       " vpiSize=%d (exp %d)\n", name,
		       (int)vpi_get(vpiVector, obj), is_vector,
		       (int)vpi_get(vpiScalar, obj), !is_vector,
		       (int)vpi_get(vpiSize, obj), size);
      set_result(call, failed);
      return 0;
}

static void register_tasks(void)
{
      s_vpi_systf_data tf = {0};
      tf.type = vpiSysFunc;
      tf.sysfunctype = vpiIntFunc;
      tf.tfname = "$check_sv";
      tf.calltf = check_sv;
      vpi_register_systf(&tf);
}

void (*vlog_startup_routines[])(void) = {register_tasks, 0};
