/*
 * Copyright © 2023 Rémi Denis-Courmont.
 *
 * This file is part of FFmpeg.
 *
 * FFmpeg is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * FFmpeg is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with FFmpeg; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

#include <stdint.h>

#include "config.h"

<<<<<<<< HEAD:libavcodec/riscv/g722dsp_init.c
#include <stdint.h>

#include "libavutil/attributes.h"
#include "libavutil/cpu.h"
<<<<<<<< HEAD:libavcodec/riscv/ac3dsp_init.c
#include "libavcodec/ac3dsp.h"

void ff_extract_exponents_rvb(uint8_t *exp, int32_t *coef, int nb_coefs);

av_cold void ff_ac3dsp_init_riscv(AC3DSPContext *c)
{
    int flags = av_get_cpu_flags();

    if (flags & AV_CPU_FLAG_RVB_ADDR) {
        if (flags & AV_CPU_FLAG_RVB_BASIC)
            c->extract_exponents = ff_extract_exponents_rvb;
    }
========
#include "libavutil/riscv/cpu.h"
#include "libavcodec/g722dsp.h"

extern void ff_g722_apply_qmf_rvv(const int16_t *prev_samples, int xout[2]);

av_cold void ff_g722dsp_init_riscv(G722DSPContext *dsp)
========
#include "libavutil/attributes.h"
#include "libavutil/cpu.h"
#include "libavcodec/lossless_videodsp.h"

void ff_llvid_add_bytes_rvv(uint8_t *, uint8_t *src, ptrdiff_t w);

av_cold void ff_llviddsp_init_riscv(LLVidDSPContext *c)
>>>>>>>> 0a87bd02ee6c22384961c68ca4a97f9981043885:libavcodec/riscv/llviddsp_init.c
{
#if HAVE_RVV
    int flags = av_get_cpu_flags();

<<<<<<<< HEAD:libavcodec/riscv/g722dsp_init.c
    if ((flags & AV_CPU_FLAG_RVV_I32) && ff_get_rv_vlenb() >= 16)
        dsp->apply_qmf = ff_g722_apply_qmf_rvv;
========
    if (flags & AV_CPU_FLAG_RVV_I32) {
        c->add_bytes = ff_llvid_add_bytes_rvv;
    }
>>>>>>>> 0a87bd02ee6c22384961c68ca4a97f9981043885:libavcodec/riscv/llviddsp_init.c
#endif
>>>>>>>> 0a87bd02ee6c22384961c68ca4a97f9981043885:libavcodec/riscv/g722dsp_init.c
}
